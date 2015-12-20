module Etsy
  class Transaction
    include Model

    attribute :id, :from => :transaction_id
    attribute :buyer_id, :from => :buyer_user_id
    attributes :quantity, :listing_id, :order_id, :title

    association :image, :from => 'Images'

    def self.find_all_by_shop_id(shop_id, options = {})
      get_all("/shops/#{shop_id}/transactions", options)
    end

    #Find all Transactions by the buyer_id
    #
    def self.find_all_by_buyer_id(user_id, options = {})
      get_all("/users/#{user_id}/transactions", options)
    end

    def self.find_all_by_receipt_id(receipt_id, options = {})
      get_all("/receipts/#{receipt_id}/transactions", options)
    end

    # The collection of images associated with this transaction.
    #
    def images
      @images ||= Image.find_all_by_listing_id(listing_id, oauth)
    end

    # The primary image for this transaction.
    #
    def image
      images.first
    end

    def buyer
      @buyer ||= User.find(buyer_id)
    end

  end
end
