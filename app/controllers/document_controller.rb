require 'roo'
class DocumentController < ApplicationController
	
	def index
		@binanceTrades = BinanceTrade.where(userEmail: "arturo.fernandezbautista@hotmail.com")
		@binanceHeaders = ["Date(UTC)", "Market", "Type", "Price", "Amount", "Total", "Fee", "Fee Coin"]
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
	  	    result = false
	  	end
	    
	  end

	  puts result
	  redirect_to root_path
	end

	def binance_file file
		document = Roo::Spreadsheet.open(file.path)
		  #Cumple los requisitos de binance
		  if document.row(1) == ["Date(UTC)", "Market", "Type", "Price", "Amount", "Total", "Fee", "Fee Coin"]  
		    document.each_with_index do |col, index| 
			  if index != 0 
			  result = BinanceTrade.find_or_create_by(
				  userEmail: "arturo.fernandezbautista@hotmail.com",
				  date: col[0], 
				  market: col[1],
				  tradeType: col[2],
				  price: col[3],
				  amount: col[4],
				  total: col[5],
				  fee: col[6],
				  feeCoin: col[7]
				)
			  end
			end
		  end
	end

	def delete_all
	  BinanceTrade.delete_all
	  redirect_to root_path
	end

end
