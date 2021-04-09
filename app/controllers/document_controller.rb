require 'roo'
class DocumentController < ApplicationController
	
	def index
		@binanceTrades = BinanceTrade.where(userEmail: current_user.email)
		@coinbaseTrades = CoinbaseTrade.where(userEmail: current_user.email)
		@binanceHeaders = ["Date(UTC)", "Market", "Type", "Price", "Amount", "Total", "Fee", "Fee Coin"]
		@coinbaseHeaders = ["Timestamp","Transaction Type","Asset","Quantity Transacted","EUR Spot Price at Transaction","EUR Subtotal","EUR Total (inclusive of fees)","EUR Fees","Notes"]

	end

	def new
	  
	end

	def test
	end

	def create
	  if params[:file]
	  	case params[:exchange]
	      when "Binance"
	  	    result = binance_file params[:file]
	  	  when "Coinbase"
	  	    result = coinbase_file params[:file]
	  	end
	    
	  end

	  puts result
	  redirect_to root_path
	end

	def binance_file file
		document = Roo::Spreadsheet.open(file.path,csv_options: {encoding: Encoding::UTF_8})
		  #Cumple los requisitos de binance
		  if document.row(1) == ["Date(UTC)", "Market", "Type", "Price", "Amount", "Total", "Fee", "Fee Coin"]  
		    document.each_with_index do |row, index| 
			  if index != 0 
			    result = BinanceTrade.find_or_create_by(
				  userEmail: current_user.email,
				  date: row[0], 
				  market: row[1],
				  tradeType: row[2],
				  price: row[3],
				  amount: row[4],
				  total: row[5],
				  fee: row[6],
				  feeCoin: row[7]
				)
			  end
			end
		  end
	end

	def coinbase_file file
		document = Roo::Spreadsheet.open(file.path, csv_options: {encoding: Encoding::UTF_8})
		  #Cumple los requisitos de binance
		  if document.row(8) == ["Timestamp,Transaction Type,Asset,Quantity Transacted,EUR Spot Price at Transaction,EUR Subtotal,EUR Total (inclusive of fees),EUR Fees,Notes"] 
		    document.each_with_index do |row, index| 
			  if index > 7
			    splitedRow = row[0].split(',')
			    # Delete invalid characters from coinbase xmls
			  	splitedRow.each do |s| s.delete! "\"" end
				
			    result = CoinbaseTrade.find_or_create_by(
				  userEmail: current_user.email,
				  timestamp: splitedRow[0], 
				  transactionType: splitedRow[1],
				  asset: splitedRow[2],
				  quantityTransacted: splitedRow[3],
				  eurSpotPrice: splitedRow[4],
				  eurSubtotal: splitedRow[5],
				  eurTotal: splitedRow[6],
				  eurFees: splitedRow[7],
				  notes: splitedRow[8]
				)

				if result
					wallet = Wallet.find_by(userEmail: current_user.email, asset: result.asset) 
					case result.transactionType
					when "Buy"
						if wallet
						  wallet.amount = (wallet.amount.to_f + result.quantityTransacted.to_f)
						  wallet.save
						else
						  Wallet.create(userEmail:current_user.email, asset: result.asset , amount: result.quantityTransacted)
						end
					when "Convert"
						if wallet
						  wallet.amount = (wallet.amount.to_f - result.quantityTransacted.to_f)
						  wallet.save
						else
						  Wallet.create(userEmail:current_user.email, asset: result.asset , amount: result.quantityTransacted)
						end
						#Falta añadir la otra wallet con + a lo que se le convierte
					when "Receive"
						if wallet
						  wallet.amount = (wallet.amount.to_f + result.quantityTransacted.to_f)
						  wallet.save
						else
						  Wallet.create(userEmail:current_user.email, asset: result.asset , amount: result.quantityTransacted)
						end
					when "Send"	
						if wallet
						  wallet.amount = (wallet.amount.to_f - result.quantityTransacted.to_f)
						  wallet.save
						else
						  Wallet.create(userEmail:current_user.email, asset: result.asset , amount: "-".concat(result.quantityTransacted))
						end
					when "Coinbase Earn"
						if wallet
						  wallet.amount = (wallet.amount.to_f + result.quantityTransacted.to_f)
						  wallet.save
						else
						  Wallet.create(userEmail:current_user.email, asset: result.asset , amount: result.quantityTransacted)
						end
					end
				end
			  end
			end
		  end
	end

	def delete_all
	  BinanceTrade.where(userEmail: current_user.email).destroy_all
	  CoinbaseTrade.where(userEmail: current_user.email).destroy_all
	  Wallet.where(userEmail: current_user.email).destroy_all
	  redirect_to root_path
	end

end
