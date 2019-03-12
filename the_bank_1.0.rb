# /home/dev/tts/ruby/day_5/the_bank.rb

require_relative 'bank_classes'

@customers = []

def welcome_screen
  clear_screen
  @current_customer = ''
  puts 'Welcome to the Bank'
  puts 'Please choose an option'
  puts '--------------------------'
  puts '1. Customer Sign-In'
  puts '2. New Customer Registration'

  case gets.chomp.to_i
  when 1
    sign_in
  when 2
    sign_up('', '')
  else
    puts 'Invalid selction.'
    welcome_screen
  end
end

def sign_in
  clear_screen
  puts "What's your name?"
  name = gets.chomp
  puts "What's your password?"
  password = Digest::SHA1.hexdigest gets.chomp + name.downcase

  if validate_customer? name, password
    acct_menu
  else
    clear_screen
    puts 'No customer found with that information'
    puts '1. Try again'
    puts '2. Sign up'

    case gets.chomp.to_i
    when 1
      sign_in
    when 2
      sign_up(name, password)
    end
  end
end

def validate_customer?(name, password)
  exists = false
  @customers.each do |customer|
    if name.casecmp(customer.name).zero && password == customer.password
      @current_customer = customer
      exists = true
    end
  end
  exists
end

def sign_up(name, password)
  clear_screen
  if name == '' && password == ''
    puts "What's your name"
    name = gets.chomp
    puts "What's your password"
    password = Digest::SHA1.hexdigest gets.chomp + name.downcase
  end
  @current_customer = Customer.new(name, password)
  @customers.push(@current_customer)
  puts 'Registration successful'
  puts @current_customer.password
  acct_menu
end

def acct_menu
  clear_screen
  puts 'Account Menu'
  puts '------------'
  puts '1. Create an Account'
  puts '2. Review an Account'
  puts '3. Sign Out'

  case gets.chomp.to_i
  when 1
    create_acct
  when 2
    review_acct
  when 3
    puts 'Thank you. Goodbye.'
    welcome_screen
  else
    puts 'Invalid selection.'
    acct_menu
  end
end

def create_acct
  clear_screen
  puts 'What type of account would you like to open?'
  acct_type = gets.chomp.downcase
  amount = 0
  until amount > 0
    puts 'How much will your first deposit be?'
    print '$'
    amount = gets.chomp.to_f
  end
  new_acct = Account.new(amount, @current_customer.acct_qty + 1, acct_type)
  @current_customer.accts.push new_acct
  puts 'Account created successfully.'
  acct_menu
end

def review_acct
  clear_screen
  @current_acct = ''

  if @current_customer.accts.empty?
    puts 'No accounts available to review.'
    puts 'Press [ENTER] to conutinue'
    gets.chomp
    acct_menu
  end

  puts 'Which account type do you want to review: '
  @current_customer.list_accts
  type = gets.chomp.downcase
  if @current_customer.acct_exists? type
    current_acct_actions
  else
    puts 'Try again'
    review_acct
  end
end

def current_acct_actions
  puts 'Choose from the following:'
  puts '--------------------------'
  puts '1. Balance Check'
  puts '2. Make a Deposit'
  puts '3. Make a Withdrawal'
  puts '4. Return to Account Menu'
  puts '5. Sign Out'

  case gets.chomp.to_i
  when 1
    clear_screen
    puts "Current balance is $#{format('%0.2f', @current_acct.balance)}"
    current_acct_actions
  when 2
    clear_screen
    @current_acct.deposit
    current_acct_actions
  when 3
    clear_screen
    @current_acct.withdrawal
    current_acct_actions
  when 4
    acct_menu
  when 5
    welcome_screen
  else
    puts 'Invalid Selection'
    current_acct_actions
  end
end

def clear_screen
  system 'cls' or system 'clear'
end

welcome_screen
