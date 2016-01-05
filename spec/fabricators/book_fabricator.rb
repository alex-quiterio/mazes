Fabricator(:book) do
	 author
  title { FFaker::Product.product_name }
end
