import Foundation

struct CauseData: Identifiable {
    let id: String
    let name: String
    let city: String
    let foundedYear: Int
    let mealsToday: Int        // Sunday baseline (used as fallback)
    let dailyGoal: Int
    let donorsThisWeek: Int
    let scenario: String
    let causeOptions: [String]
    let costPerMeal: Double
    let bio: String
    let websiteURL: String
    // Per-day baselines matching the dashboard's CAUSE_BASELINE.dailyMealsByDay
    let dailyMealsByDay: [String: Int]

    /// Returns today's baseline meal count (day-of-week aware, matches dashboard)
    var mealsForToday: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"  // "Mon", "Tue", etc.
        let dayKey = formatter.string(from: Date())
        return dailyMealsByDay[dayKey] ?? mealsToday
    }

    var progress: Double {
        guard dailyGoal > 0 else { return 0 }
        return Double(mealsToday) / Double(dailyGoal)
    }

    static let allCauses: [CauseData] = [
        CauseData(
            id: "hamilton-food-share",
            name: "Hamilton Food Share",
            city: "Hamilton, ON",
            foundedYear: 1984,
            mealsToday: 849,
            dailyGoal: 1000,
            donorsThisWeek: 94,
            scenario: "A single mom skipped lunch so her kids could eat. Your gift means she doesn't have to choose.",
            causeOptions: ["Emergency food hampers", "Children's breakfast"],
            costPerMeal: 2.50,
            bio: "Hamilton Food Share has been the central food distribution hub for Hamilton since 1984. They coordinate a network of 160+ emergency food programs and served over 18,000 people monthly in 2024.",
            websiteURL: "https://www.hamiltonfoodshare.org",
            dailyMealsByDay: ["Sun": 849, "Mon": 912, "Tue": 978, "Wed": 1034, "Thu": 964, "Fri": 1018, "Sat": 887]
        ),
        CauseData(
            id: "toronto-daily-bread",
            name: "Daily Bread Food Bank",
            city: "Toronto, ON",
            foundedYear: 1983,
            mealsToday: 1204,
            dailyGoal: 1500,
            donorsThisWeek: 217,
            scenario: "A retired teacher lines up before dawn. Your gift keeps the shelves stocked when she arrives.",
            causeOptions: ["Hot meal programs", "Grocery essentials"],
            costPerMeal: 2.00,
            bio: "Daily Bread Food Bank has fought hunger in Toronto since 1983. They operate the city's largest network of food programs, serving over 270,000 client visits per month across 200+ member agencies.",
            websiteURL: "https://www.dailybread.ca",
            dailyMealsByDay: ["Sun": 1204, "Mon": 1275, "Tue": 1388, "Wed": 1492, "Thu": 1420, "Fri": 1510, "Sat": 1330]
        ),
        CauseData(
            id: "vancouver-food-bank",
            name: "Greater Vancouver Food Bank",
            city: "Vancouver, BC",
            foundedYear: 1982,
            mealsToday: 673,
            dailyGoal: 900,
            donorsThisWeek: 156,
            scenario: "A student chose rent over food this month. Your gift makes sure no one goes hungry tonight.",
            causeOptions: ["Community kitchen", "Student meal packs"],
            costPerMeal: 3.00,
            bio: "Greater Vancouver Food Bank is BC's largest food bank, established in 1982. They provide food to over 100,000 people each month through 150 community agency members across Metro Vancouver.",
            websiteURL: "https://www.foodbank.bc.ca",
            dailyMealsByDay: ["Sun": 673, "Mon": 744, "Tue": 831, "Wed": 918, "Thu": 864, "Fri": 902, "Sat": 790]
        ),
    ]

    static func cause(for id: String) -> CauseData {
        allCauses.first { $0.id == id } ?? allCauses[0]
    }
}
