ActiveAdmin.register Product do
  permit_params :name, :description, :price, :stock_quantity, :category


  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :description
      f.input :price
      f.input :stock_quantity
      f.input :category
    end
    f.actions
  end
end
