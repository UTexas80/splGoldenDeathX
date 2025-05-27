import pandas as pd
from datetime import datetime
from dateutil.relativedelta import relativedelta
from decimal import Decimal, getcontext

# Set precision for Decimal calculations
getcontext().prec = 28

# Financial Constants
# Credit Card
CC_INITIAL_BALANCE = Decimal('75000.00')
CC_ANNUAL_INTEREST_RATE = Decimal('0.20')  # 20%
CC_MONTHLY_INTEREST_RATE = CC_ANNUAL_INTEREST_RATE / Decimal('12')
CC_FIXED_BASE_PAYMENT = Decimal('2000.00')

# Mortgage
MORTGAGE_INITIAL_BALANCE = Decimal('250000.00')
MORTGAGE_ANNUAL_INTEREST_RATE = Decimal('0.034')  # 3.4%
MORTGAGE_MONTHLY_INTEREST_RATE = MORTGAGE_ANNUAL_INTEREST_RATE / Decimal('12')
MORTGAGE_FIXED_MONTHLY_PAYMENT = Decimal('1500.00')

# Investments
INVESTMENT_INITIAL_BALANCE = Decimal('0.00')
INVESTMENT_ANNUAL_RETURN_RATE = Decimal('0.06')  # 6%
INVESTMENT_MONTHLY_RETURN_RATE = INVESTMENT_ANNUAL_RETURN_RATE / Decimal('12')

# Post-CC Debt SS Allocation
POST_CC_DEBT_SS_FIXED_PAYMENT = Decimal('1500.00')

# Employment and Living Expenses (New)
EMPLOYMENT_INCOME_GROSS_MONTHLY = Decimal('10000.00')
EMPLOYMENT_INCOME_TAX_RATE = Decimal('0.15')  # 15% flat tax
NET_EMPLOYMENT_INCOME_MONTHLY = (EMPLOYMENT_INCOME_GROSS_MONTHLY * (Decimal('1.0') - EMPLOYMENT_INCOME_TAX_RATE)).quantize(Decimal('0.01'))
MONTHLY_LIVING_EXPENSES_TOTAL = Decimal('10000.00') # Includes $2k CC base and $1.5k mortgage payments
RETIREMENT_AGE_YEARS = 70

# Note: The deficit of (NET_EMPLOYMENT_INCOME_MONTHLY - MONTHLY_LIVING_EXPENSES_TOTAL)
# which is $8500 - $10000 = -$1500 per month during employment,
# is assumed to be covered by external, unmodeled savings.

# Simulation Period
SIMULATION_START_DATE = datetime(2025, 1, 1)
SIMULATION_END_DATE = datetime(2050, 12, 1)  # Inclusive of Dec 2050

# Birth Date
BIRTH_DATE = datetime(1957, 5, 1)

# Social Security Scenarios
SCENARIOS = [
    {
        "name": "S68_5",
        "start_date": datetime(2025, 11, 1),
        "monthly_benefit": Decimal("3633.00"),
        # Age at start: 68 years, 6 months
    },
    {
        "name": "S69",
        "start_date": datetime(2026, 5, 1),
        "monthly_benefit": Decimal("3936.00"),
        # Age at start: 69 years, 0 months
    },
    {
        "name": "S70",
        "start_date": datetime(2027, 5, 1),
        "monthly_benefit": Decimal("4334.00"),
        # Age at start: 70 years, 0 months
    },
]

if __name__ == "__main__":
    all_scenarios_data_frames = []

    for scenario_config in SCENARIOS:
        print(f"Processing Scenario: {scenario_config['name']}")

        current_cc_balance = CC_INITIAL_BALANCE
        current_mortgage_balance = MORTGAGE_INITIAL_BALANCE
        current_investment_balance = INVESTMENT_INITIAL_BALANCE
        cumulative_ss_income = Decimal('0.00')
        cc_debt_paid_off = False
        monthly_records = []

        date_range = pd.date_range(SIMULATION_START_DATE, SIMULATION_END_DATE, freq='MS')

        for current_month_date in date_range:
            # A. Date and Age
            age_details = relativedelta(current_month_date, BIRTH_DATE)
            age_str = f"{age_details.years} years, {age_details.months} months"
            current_age_years = age_details.years

            # B. Determine Employment Status & Income
            net_employment_income_this_month = Decimal('0.00')
            employment_status_this_month = "Retired" # Default to Retired
            if current_age_years < RETIREMENT_AGE_YEARS:
                net_employment_income_this_month = NET_EMPLOYMENT_INCOME_MONTHLY
                employment_status_this_month = "Employed"

            # C. Social Security Income
            ss_income_this_month = Decimal('0.00')
            if current_month_date >= scenario_config["start_date"]:
                ss_income_this_month = scenario_config["monthly_benefit"]
                cumulative_ss_income += ss_income_this_month

            # D. Credit Card Calculation (Revised Call)
            cc_interest_paid_this_month = Decimal('0.00')
            cc_principal_paid_this_month = Decimal('0.00')
            cc_payment_made_this_month = Decimal('0.00')
            ss_supplement_for_cc = Decimal('0.00')

            if not cc_debt_paid_off:
                if current_age_years < RETIREMENT_AGE_YEARS and ss_income_this_month > 0:
                    ss_supplement_for_cc = ss_income_this_month
                
                # CC_FIXED_BASE_PAYMENT is part of MONTHLY_LIVING_EXPENSES_TOTAL, which is assumed covered by employment income or unmodeled savings.
                # update_credit_card_balance sums its 'base_payment' and 'ss_income_for_month' args.
                # Here, 'base_payment' is the standard CC payment, and 'ss_income_for_month' is any *additional* SS money to accelerate it.
                cc_interest_paid_this_month, cc_principal_paid_this_month, cc_payment_made_this_month, new_cc_balance = \
                    update_credit_card_balance(current_cc_balance, CC_MONTHLY_INTEREST_RATE, 
                                               base_payment=CC_FIXED_BASE_PAYMENT, 
                                               ss_income_for_month=ss_supplement_for_cc) # ss_supplement_for_cc is the SS portion for CC
                current_cc_balance = new_cc_balance
                if current_cc_balance == Decimal('0.00'):
                    cc_debt_paid_off = True
                    print(f"CC debt paid off in {current_month_date.strftime('%Y-%m')} for scenario {scenario_config['name']}")
            # else: CC debt already paid, no CC payment needed, values remain zero.


            # E. Mortgage Payment (logic unchanged, payment included in MONTHLY_LIVING_EXPENSES_TOTAL)
            # The $1500 mortgage payment is part of the $10000 MONTHLY_LIVING_EXPENSES_TOTAL.
            # It's assumed paid from the overall budget.
            mort_interest_paid, mort_principal_paid, new_mort_balance = \
                update_mortgage_balance(current_mortgage_balance, MORTGAGE_MONTHLY_INTEREST_RATE, MORTGAGE_FIXED_MONTHLY_PAYMENT)
            current_mortgage_balance = new_mort_balance

            # F. Investment Contribution and Growth (Thoroughly Revised Logic)
            investment_contribution_this_month = Decimal('0.00')
            if cc_debt_paid_off:
                # General living expenses: Total monthly expenses MINUS the CC base payment (now paid off) 
                # and MINUS the mortgage payment (which is handled by its own update_mortgage_balance).
                general_living_expenses_excluding_cc_base_and_mortgage = MONTHLY_LIVING_EXPENSES_TOTAL - CC_FIXED_BASE_PAYMENT - MORTGAGE_FIXED_MONTHLY_PAYMENT
                
                # Income available after general living expenses (but before specific SS allocation for post-CC payment)
                discretionary_income_after_general_expenses = net_employment_income_this_month - general_living_expenses_excluding_cc_base_and_mortgage
                
                # This is the pool of money from which investments and the specific $1500 SS allocation will come.
                # It includes any remaining net employment income plus ALL SS income for the month.
                cash_pool_for_investment_and_specific_ss_allocation = discretionary_income_after_general_expenses + ss_income_this_month
                
                # Determine how much of the SS income is used for the POST_CC_DEBT_SS_FIXED_PAYMENT
                ss_money_used_for_post_cc_fixed_payment = Decimal('0.00')
                if ss_income_this_month > 0: # This special allocation only applies if SS is active
                    ss_money_used_for_post_cc_fixed_payment = min(ss_income_this_month, POST_CC_DEBT_SS_FIXED_PAYMENT)
                
                # The investment contribution is what's left from the cash pool after the specific SS allocation.
                investment_contribution_this_month = cash_pool_for_investment_and_specific_ss_allocation - ss_money_used_for_post_cc_fixed_payment
                investment_contribution_this_month = max(Decimal('0.00'), investment_contribution_this_month) # Ensure not negative

            current_investment_balance = update_investment_balance(
                current_investment_balance, INVESTMENT_MONTHLY_RETURN_RATE, investment_contribution_this_month
            )

            # G. Record Monthly Data (Add New Fields)
            monthly_records.append({
                'Date': current_month_date.strftime('%Y-%m'),
                'Age': age_str,
                'Employment_Status': employment_status_this_month,
                'Net_Employment_Income': net_employment_income_this_month,
                'SS_Income': ss_income_this_month,
                'Cumulative_SS_Income': cumulative_ss_income,
                'CC_Payment': cc_payment_made_this_month,
                'CC_Interest_Paid': cc_interest_paid_this_month,
                'CC_Principal_Paid': cc_principal_paid_this_month,
                'CC_Balance': current_cc_balance,
                'Investment_Contribution': investment_contribution_this_month,
                'Investment_Balance': current_investment_balance,
                # Optional: include mortgage details for detailed tracking
                # 'Mortgage_Payment_Made': MORTGAGE_FIXED_MONTHLY_PAYMENT, # This is constant if balance > 0
                'Mortgage_Interest_Paid': mort_interest_paid,
                'Mortgage_Principal_Paid': mort_principal_paid,
                'Mortgage_Balance': current_mortgage_balance
            })

        df = pd.DataFrame(monthly_records)
        df['Scenario'] = scenario_config['name']
        all_scenarios_data_frames.append(df)

    print("All scenarios processed. Ready for data consolidation.")

    if not all_scenarios_data_frames:
        print("No scenario data to process.")
    else:
        print("Consolidating data from all scenarios...")
        common_age_series = all_scenarios_data_frames[0].set_index('Date')['Age']
        common_date_index = all_scenarios_data_frames[0].set_index('Date').index # Keep the date index

        scenario_specific_dfs = []
        column_order = ['Date', 'Age'] # Start of the desired column order

        for df_original in all_scenarios_data_frames:
            scenario_name = df_original['Scenario'].iloc[0]
            temp_df = df_original.set_index('Date').copy()
            temp_df = temp_df.drop(columns=['Age', 'Scenario']) # Drop original Age and Scenario columns

            # Rename columns for this specific scenario
            renamed_columns = {}
            for col in temp_df.columns:
                new_col_name = f"{col}_{scenario_name}"
                renamed_columns[col] = new_col_name
                # Add to overall column order, ensuring scenario-specific columns are grouped
                if scenario_name == SCENARIOS[0]["name"]: # Add base names for the first scenario
                    column_order.append(new_col_name)
                elif new_col_name not in column_order : # For subsequent scenarios, ensure grouping
                     # This simple append might not group perfectly if columns differ wildly;
                     # a more robust grouping would be needed for complex cases.
                     # For this specific problem, columns are consistent across scenarios before renaming.
                     column_order.append(new_col_name)


            temp_df.rename(columns=renamed_columns, inplace=True)
            scenario_specific_dfs.append(temp_df)

        # Re-create column order for proper grouping by scenario
        final_column_order = ['Date', 'Age']
        original_data_cols_template = [ # Based on the keys in monthly_records, excluding Date, Age
            'Employment_Status', 'Net_Employment_Income', 'SS_Income', 'Cumulative_SS_Income', 
            'CC_Payment', 'CC_Interest_Paid', 'CC_Principal_Paid', 'CC_Balance', 
            'Investment_Contribution', 'Investment_Balance', 
            'Mortgage_Interest_Paid', 'Mortgage_Principal_Paid', 'Mortgage_Balance' # Added mortgage details
        ]
        for scenario_config in SCENARIOS:
            scenario_name = scenario_config['name']
            for col_template in original_data_cols_template:
                final_column_order.append(f"{col_template}_{scenario_name}")


        if scenario_specific_dfs:
            # Concatenate all scenario-specific dataframes (they are already indexed by Date)
            final_combined_df = pd.concat(scenario_specific_dfs, axis=1)

            # Add the common 'Age' series (it's already indexed by Date)
            # Ensure it aligns with the final_combined_df's index
            final_combined_df = pd.concat([common_age_series.reindex(final_combined_df.index), final_combined_df], axis=1)
            
            # Reset index to bring 'Date' back as a column
            final_combined_df.reset_index(inplace=True)
            
            # Ensure 'Date' is the very first column if not already
            if 'Date' in final_combined_df.columns and final_combined_df.columns[0] != 'Date':
                cols = ['Date'] + [col for col in final_combined_df.columns if col != 'Date']
                final_combined_df = final_combined_df[cols]

            # Apply the desired column order
            # Filter final_column_order to only include columns present in final_combined_df
            # This handles cases where a column might have been unexpectedly dropped or not created.
            ordered_columns_present = [col for col in final_column_order if col in final_combined_df.columns]
            final_combined_df = final_combined_df[ordered_columns_present]


            print("\nConsolidated Monthly Data for All Scenarios:")
            pd.set_option('display.max_columns', None)
            pd.set_option('display.width', 200) # Adjust width as needed for your display
            print(final_combined_df.to_string())

            # Suggest Saving to CSV
            # final_combined_df.to_csv('social_security_scenario_analysis.csv', index=False)
            print("\n# To save the above table to CSV, uncomment the line above the 'Core Financial Calculation Functions' section in the script.")
            print("# Example: final_combined_df.to_csv('social_security_scenario_analysis.csv', index=False)")

        else:
            print("No scenario-specific dataframes were processed for consolidation.")

# --- Core Financial Calculation Functions ---

def calculate_age(current_date, birth_date):
    """Calculates age as a string in years and months."""
    age = relativedelta(current_date, birth_date)
    return f"{age.years} years, {age.months} months"

def update_credit_card_balance(current_balance, monthly_interest_rate, base_payment, ss_income_for_month):
    """
    Updates the credit card balance for one month.
    Returns: interest_paid_component, principal_paid_component, actual_payment, new_balance
    """
    if current_balance <= Decimal('0'):
        return Decimal('0'), Decimal('0'), Decimal('0'), Decimal('0')

    interest_due = (current_balance * monthly_interest_rate).quantize(Decimal('0.01'))
    total_payment_available = base_payment + ss_income_for_month
    
    # Actual payment cannot exceed what's needed to clear the balance
    actual_payment = min(total_payment_available, current_balance + interest_due)

    interest_paid_component = min(actual_payment, interest_due)
    principal_paid_component = actual_payment - interest_paid_component
    
    new_balance = current_balance + interest_due - actual_payment
    return interest_paid_component, principal_paid_component, actual_payment, max(Decimal('0'), new_balance)

def update_mortgage_balance(current_balance, monthly_interest_rate, fixed_payment):
    """
    Updates the mortgage balance for one month.
    Returns: interest_paid_component, principal_paid_component, new_balance
    """
    if current_balance <= Decimal('0'):
        return Decimal('0'), Decimal('0'), Decimal('0')

    interest_on_balance = (current_balance * monthly_interest_rate).quantize(Decimal('0.01'))
    
    # Payment for the month is the fixed payment, unless the balance (plus interest) is less
    payment_this_month = min(fixed_payment, current_balance + interest_on_balance)

    interest_paid_component = min(payment_this_month, interest_on_balance)
    principal_paid_component = payment_this_month - interest_paid_component
    
    new_balance = current_balance - principal_paid_component
    return interest_paid_component, principal_paid_component, max(Decimal('0'), new_balance)

def update_investment_balance(current_balance, monthly_return_rate, contribution_this_month):
    """
    Updates the investment balance for one month.
    Returns: new_balance
    """
    growth = (current_balance * monthly_return_rate).quantize(Decimal('0.01'))
    new_balance = current_balance + growth + contribution_this_month
    return new_balance
