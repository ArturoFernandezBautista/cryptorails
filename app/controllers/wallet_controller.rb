class WalletController < ApplicationController
	def index
		@wallets = Wallet.where(userEmail:current_user.email)
	end
end
