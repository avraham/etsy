module Etsy
  class Receipt
    include Model

    attribute :id, :from => :receipt_id
    attribute :buyer_id, :from => :buyer_user_id

    attributes :order_id, :name, :first_line, :second_line, :city, :state, :zip, :country_id,
               :payment_email, :buyer_email, :creation_tsz, :message_from_buyer, :last_modified_tsz

    association :transactions, :from => 'Transactions'

    def self.find_all_by_shop_id(shop_id, options = {})
      get_all("/shops/#{shop_id}/receipts", options)
    end

    def created_at
      Time.at(creation_tsz)
    end

    def updated_at
      Time.at(last_modified_tsz)
    end

    def buyer
      @buyer ||= User.find(buyer_id)
    end

    def transactions
      @transactions ||= Transactions.find_all_by_receipt_id(id, oauth)
    end

    private
    def oauth
      oauth = (token && secret) ? {:access_token => token, :access_secret => secret} : {}
    end

  end
end
