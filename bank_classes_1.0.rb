# /home/elliott/dev/tts/ruby/day_5/bank_classes.rb

require 'digest/sha1'

class Customer
  attr_accessor :name, :password, :accts

  def initialize(name, password)
    @name = name
    @password = password
    @accts = []
  end

  def list_accts
    @accts.each do |account|
      puts account.acct_type
    end
  end

  def acct_exists?(type)
    exists = false
    @accts.each do |account|
      if type == account.acct_type
        @current_acct = account
        exists = true
      end
    end
    exists
  end

  def acct_qty
    @accts.length
  end
end

class Account
  attr_reader :acct_number, :balance
  attr_accessor :customer, :acct_type

  def initialize(balance, acct_number, acct_type)
    @balance = balance
    @acct_number = acct_number
    @acct_type = acct_type
  end

  def deposit
    amount = 0
    until amount > 0
      puts 'How much would you like to deposit?'
      print '$'
      amount = gets.chomp.to_f
    end
    @balance += amount
    puts "Your new balance is $#{format('%0.2f', @balance)}"
  end

  def withdrawal
    amount = 0
    until amount > 0
      puts 'How much would you like to withdraw?'
      print '$'
      amount = gets.chomp.to_f
    end
    @balance -= @balance < amount ? (amount + 25) :  amount
    puts "Your new balance is $#{format('%0.2f', @balance)}"
  end
end
