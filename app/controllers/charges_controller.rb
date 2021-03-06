class ChargesController < ApplicationController


	 def new
	   @stripe_btn_data = {
	     key: "#{ Rails.configuration.stripe[:publishable_key] }",
	     description: "Premium Plan - #{current_user.name}",
	     amount: Amount.default
	   }
	 end

	 def create
	 
		   # Creates a Stripe Customer object, for associating
		   # with the charge
		   customer = Stripe::Customer.create(
		     email: current_user.email,
		     card: params[:stripeToken]
		   )
		 
		   # Where the real magic happens
		   charge = Stripe::Charge.create(
		     customer: customer.id, # Note -- this is NOT the  user_id in your app
		     amount: Amount.default,
		     description: "Premium Plan - #{current_user.email}",
		     currency: 'usd'
		   )

		   current_user.premium!
		 
		   flash[:notice] = "Thank you #{current_user.name}! Your payment was processed!"
		   redirect_to user_path(current_user) # or wherever
		 
		 # Stripe will send back CardErrors, with friendly messages
		 # when something goes wrong.
		 # This `rescue block` catches and displays those errors.
		 rescue Stripe::CardError => e
		   flash.now[:alert] = e.message
		   redirect_to new_charge_path

	 end


	 def destroy

		   current_user.standard!
		   current_user.downgrading_wikis!
		 
		   flash[:notice] = "#{current_user.name}, your account has now been downgraded."
		   redirect_to user_path(current_user)


	 end



end