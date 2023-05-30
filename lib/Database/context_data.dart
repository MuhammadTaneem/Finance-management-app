class ContextOptions {


  final List<String> _incomeOptions = [
    'Salary',
    'Bonus',
    'Interest',
    'Rental Income',
    'Business Income',
    'Capital Gains',
    'Commissions',
    'Tips',
    'Royalties',
    'Dividends',
    'Annuities',
    'Pension',
    'Social Security',
    'Child Support',
    'Alimony',
    'Inheritance',
    'Gifts',
    'Other',
  ];

  get incomeOption {
    return [..._incomeOptions];
  }

  final List<String> _expenseOptions = [
    "Rent",
    "Food",
    "Mortgage",
    "Property taxes",
    "Homeowners/renters insurance",
    "Utilities (electricity, gas, water, etc.)",
    "Internet",
    "Cable/satellite TV",
    "Phone (landline or mobile)",
    "Groceries",
    "Eating out",
    "Transportation (car payments, gas, maintenance, etc.)",
    "Public transportation (bus, train, etc.)",
    "Insurance (car, health, life, etc.)",
    "Personal care (haircuts, toiletries, etc.)",
    "Clothing",
    "Entertainment (movies, concerts, etc.)",
    "Gym membership",
    "Charitable donations",
    "Savings",
    "Debt repayment (credit card, student loans, etc.)",
    "Investments",
    "Travel",
    "Pets",
    "Childcare",
    "Education (tuition, textbooks, etc.)"
  ];

  get expenseOption {
    return [..._expenseOptions];
  }

  final List<String> _assetsOptions = [
    "Investment",
    "Deposit",
    "Lent",
  ];

  get assetsOption {
    return [..._assetsOptions];
  }

}