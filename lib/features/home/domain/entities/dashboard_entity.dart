class RecentActivityItemEntity {
  final String title;
  final String date;
  final double amount;
  final bool isCredit;

  const RecentActivityItemEntity({
    required this.title,
    required this.date,
    required this.amount,
    required this.isCredit,
  });

  factory RecentActivityItemEntity.fromJson(Map<String, dynamic> json) {
    return RecentActivityItemEntity(
      title: json['title']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      isCredit: json['isCredit'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'amount': amount,
      'isCredit': isCredit,
    };
  }
}

class DashboardEntity {
  final String userName;
  final double loanAmount;
  final double accountBalance;
  final String accountNumber;
  final List<RecentActivityItemEntity> recentActivity;

  const DashboardEntity({
    required this.userName,
    required this.loanAmount,
    required this.accountBalance,
    required this.accountNumber,
    this.recentActivity = const [],
  });

  factory DashboardEntity.fromJson(Map<String, dynamic> json) {
    return DashboardEntity(
      userName: json['userName']?.toString() ?? '',
      loanAmount: (json['loanAmount'] ?? 0).toDouble(),
      accountBalance: (json['accountBalance'] ?? 0).toDouble(),
      accountNumber: json['accountNumber']?.toString() ?? '',
      recentActivity: (json['recentActivity'] as List<dynamic>? ?? [])
          .map((e) => RecentActivityItemEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'loanAmount': loanAmount,
      'accountBalance': accountBalance,
      'accountNumber': accountNumber,
      'recentActivity': recentActivity.map((e) => e.toJson()).toList(),
    };
  }
}

typedef DashboardModel = DashboardEntity;
typedef RecentActivityItem = RecentActivityItemEntity;
