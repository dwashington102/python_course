# This is a program for the Dash Cell Phone Company that accepts data about text messages for customers.
# They charge customers a basic rate of $5 per month to send text messages.
# Additional rates are as follows:
# The first 60 messages per month, regardless of message length, are included in the basic bill.
# An additional five cents is charged for each text message after the 60th message, up to 180 messages.
# An additional 10 cents is charged for each text message after the 180th message.
# Federal, state, and local taxes add a total of 12 percent to each bill.
# Calculate the payment owed for a customer based on input from the customer's text message usage for the month

# Define GLOBAL_CONSTANT variables
BASE_MSG = 60
BASE_RATE = 5.00            # Defines monthly rate of $5 for each customer. Provides up to 60 free messages per month
TIER1_MSG = 180 - 61             # Used to set the
TIER2_MSG = 181
RATE_MSG_TIER2 = .10        # Rate structure charge .10 per messages above 180
RATE_MSG_TIER1 = .05  # Rate structure charge .05 per message when number of messages is >= 61 and <= 181
TAX_RATE = .12               # Federal, state, and local taxes add a total of 12 percent to each bill


# Initialize global variables to 0.
msg_total = 0  #Assigned to user input
msg_total_int = 0  #Converts assigned user input into a integer because there is no such thing as half a message

base_tot_tax = 0  #Compute BASE_RATE multiplied by TAX_RATE
base_tot_due = 0  #Compute total due adding base_tot_tax and TAX_RATE

tier1_msg_overage = 0
tier2_msg_overage = 0

# Gather Global Variables
msg_total= float(input('Numbers of messages sent for the month:  ')) #User input gathering number of messages for month
msg_total_int = int(msg_total)                  # Convert msg_total to int. because the cannot be a .5 of a message
print('\nBASE Services allows 60 messages at no cost.')
print('TIER1 Pricing charges .05 cents per message after 60 free messages.')
print('TIER2 Pricing charges .10 cents per message starting at message number 181.')

if msg_total_int < BASE_MSG:
    base_tot_tax = float(BASE_RATE * TAX_RATE)
    base_tot_due = BASE_RATE + base_tot_tax

    # Print output to console
    print("\nTotal Monthly Cost: ${:.2f}".format(base_tot_due))
    print("\nItemized Bill:\nBASE Rate: ${:.2f}".format(BASE_RATE))
    print("Overage Rate: $0.00")
    print("Tax: ${:.2f}".format(base_tot_tax))

elif msg_total_int < TIER2_MSG:
    tier1_msg_overage = msg_total_int - BASE_MSG
    tier1_overage_rate = float(tier1_msg_overage * .05)
    tier1_tot_tax = float((BASE_RATE + tier1_overage_rate) * TAX_RATE)
    tier1_tot_due = float(BASE_RATE + tier1_overage_rate + tier1_tot_tax)

    # Print output to console
    print("\nTotal Monthly Cost: ${:.2f}".format(tier1_tot_due))
    print("\nItemized Bill:\nBASE Rate: ${:.2f}".format(BASE_RATE))
    print("Overage Rate: ${:.2f}".format(tier1_overage_rate))
    print("Tax: ${:.2f}".format(tier1_tot_tax))

else:
    tier1_overage_rate = float(TIER1_MSG * .05)
    tier2_msg_overage = msg_total_int - 180
    tier2_overage_rate = float(tier2_msg_overage * .10)
    tier2_tot_tax = float((BASE_RATE + tier2_overage_rate + tier1_msg_overage) * TAX_RATE)
    tier2_tot_due = float(BASE_RATE + tier2_overage_rate + tier1_overage_rate + tier2_tot_tax)

    # Print output to console
    print("\nTotal Monthly Cost: ${:.2f}".format(tier2_tot_due))
    print("\nItemized Bill:\nBASE Rate: ${:.2f}".format(BASE_RATE))
    print("Overage Rate: ${:.2f}".format(tier2_overage_rate + tier1_overage_rate))
    print("Tax: ${:.2f}".format(tier2_tot_tax))

