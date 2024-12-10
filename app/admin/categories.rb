# frozen_string_literal: true

ActiveAdmin.register Category do
  permit_params :name

  index do
    selectable_column
    id_column
    column :name
    column :created_at
    actions
  end

  form do |f|
    f.inputs 'Category Details' do
      f.input :name
    end
    f.actions
  end

  show do
    attributes_table do
      row :name
      row :created_at
      row :updated_at
    end

    panel 'Products in this Category' do
      table_for category.products do
        column :name
        column :price
        column :stock_quantity
        column :actions do |product|
          link_to 'View Product', admin_product_path(product)
        end
      end
    end
  end
end
