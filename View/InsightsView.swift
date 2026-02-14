import SwiftUI

struct InsightsView: View {
    @StateObject private var viewModel = InsightsViewModel()
    
    var body: some View {
        NavigationView {
             List {
                ForEach(viewModel.stats) { stat in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(stat.name)
                                .font(.headline)
                            Text("\(stat.totalSessions) sessions attended")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text(String(format: "%.0f%%", stat.promptRate * 100))
                                .fontWeight(.bold)
                                .foregroundColor(colorForRate(stat.promptRate))
                            Text("Promptness")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Insights")
            .onAppear {
                viewModel.fetchStats()
            }
            .refreshable {
                viewModel.fetchStats()
            }
        }
    }
    
    func colorForRate(_ rate: Double) -> Color {
        if rate >= 0.8 { return .green }
        if rate >= 0.5 { return .orange }
        return .red
    }
}
