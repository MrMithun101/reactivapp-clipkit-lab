import SwiftUI

struct CauseLandingView: View {
    let cause: CauseData
    @EnvironmentObject var donationState: DonationState

    @State private var liveMealsToday: Int = 0

    private static let backboardAPIKey = "espr_N8iIQE8wNuJCq1VKebscrrB23EbGvbLHGaQF7BZoD54"
    private static let backboardAssistantId = "6ae73c6a-9d50-47fa-a224-cecb3b4e94d4"

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Image(systemName: "fork.knife")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 80, height: 80)
                    .background(.giveGreen, in: Circle())
                    .padding(.top, 24)

                VStack(spacing: 4) {
                    Text(cause.name)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.giveTextPrimary)
                        .multilineTextAlignment(.center)
                    Text(cause.city)
                        .font(.system(size: 16))
                        .foregroundStyle(.giveTextSecondary)
                }

                Text("Neighbours helping neighbours in \(cause.city)")
                    .font(.system(size: 16).italic())
                    .foregroundStyle(.giveGreen)

                VStack(spacing: 8) {
                    Text(cause.bio)
                        .font(.system(size: 13))
                        .foregroundStyle(.giveTextSecondary)
                        .multilineTextAlignment(.center)

                    if let url = URL(string: cause.websiteURL) {
                        Link(destination: url) {
                            HStack(spacing: 4) {
                                Image(systemName: "globe")
                                    .font(.system(size: 12))
                                Text(cause.websiteURL.replacingOccurrences(of: "https://www.", with: ""))
                                    .font(.system(size: 13, weight: .medium))
                            }
                            .foregroundStyle(.giveGreen)
                        }
                    }
                }
                .padding(.horizontal, 24)

                Text(cause.scenario)
                    .font(.system(size: 14).italic())
                    .foregroundStyle(.giveTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, 32)

                GoalProgressBar(current: liveMealsToday, goal: cause.dailyGoal)
                    .padding(.horizontal, 16)

                HStack(spacing: 4) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(.giveTextSecondary)
                    Text("\(cause.donorsThisWeek) people gave in \(cause.city) this week")
                        .font(.system(size: 13))
                        .foregroundStyle(.giveTextSecondary)
                }

                CityLeaderboard(currentCauseId: cause.id)
                    .padding(.horizontal, 16)

                Button {
                    withAnimation(.spring(duration: 0.35)) {
                        donationState.currentScreen = .amount
                    }
                } label: {
                    Text("Feed Someone Today")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(.giveGreen, in: RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 16)
        }
        .scrollIndicators(.hidden)
        .onAppear {
            liveMealsToday = cause.mealsForToday
            donationState.liveMealsBaseline = cause.mealsForToday
            Task { await fetchLiveMeals() }
        }
    }

    // Fetch today's donation memories from Backboard and add to the day's baseline
    private func fetchLiveMeals() async {
        guard let url = URL(string: "https://app.backboard.io/api/assistants/\(Self.backboardAssistantId)/memories") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(Self.backboardAPIKey, forHTTPHeaderField: "X-API-Key")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        guard let (data, _) = try? await URLSession.shared.data(for: request),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let memories = json["memories"] as? [[String: Any]] else { return }

        let calendar = Calendar.current
        let todayStart = calendar.startOfDay(for: Date())
        let isoFormatter = ISO8601DateFormatter()

        let todayMeals = memories
            .filter { memory in
                guard let meta = memory["metadata"] as? [String: Any],
                      let causeId = meta["causeId"] as? String,
                      causeId == cause.id,
                      let tsStr = meta["timestamp"] as? String,
                      let ts = isoFormatter.date(from: tsStr) else { return false }
                return ts >= todayStart
            }
            .compactMap { memory -> Int? in
                (memory["metadata"] as? [String: Any]).flatMap { $0["meals"] as? Int }
            }
            .reduce(0, +)

        await MainActor.run {
            liveMealsToday = cause.mealsForToday + todayMeals
            donationState.liveMealsBaseline = liveMealsToday
        }
    }
}
