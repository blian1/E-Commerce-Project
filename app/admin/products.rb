ActiveAdmin.register Product do
  permit_params :name, :description, :price, :stock_quantity, :category_id, images: [], remove_images: []

  config.filters = true

  filter :name
  filter :price
  filter :stock_quantity
  filter :category
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column :name
    column :price
    column :stock_quantity
    column :category
    actions
  end

  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :description
      f.input :price
      f.input :stock_quantity
      f.input :category, as: :select, collection: Category.all.map { |c| [ c.name, c.id ] }, include_blank: "Select a Category"
    end

    # Display existing images
    if f.object.images.attached?
      panel "Existing Images" do
        ul do
          f.object.images.each_with_index do |img, index|
            li do
              # Display the image
              div do
                image_tag url_for(img), size: "250x250", style: "margin-bottom: 10px;"
              end

              # Generate a unique checkbox and label for each image
              div do
                check_box_id = "remove_image_#{index}"

                # Directly join HTML, ensuring each div is independent
                safe_join([
                  check_box_tag("product[remove_images][]", img.id, false, id: check_box_id),
                  label_tag(check_box_id, "Remove this image")
                ])
              end
            end
          end
        end
      end
    end

    # Upload new images
    f.inputs "Add New Images" do
      f.input :images, as: :file, input_html: { multiple: true }
    end

    f.actions
  end
  show do
    attributes_table do
      row :name
      row :description
      row :price
      row :stock_quantity
      row :category
      row :images do |product|
        if product.images.attached?
          product.images.map do |img|
            image_tag url_for(img), size: "300x300"
          end.join(" ").html_safe
        else
          "No images uploaded"
        end
      end
    end
  end

  controller do
    def update
      # Remove selected images
      if params[:product][:remove_images]
        params[:product][:remove_images].each do |image_id|
          image = ActiveStorage::Attachment.find(image_id)
          image.purge # Delete image
        end

        # Remove the remove_images parameter to avoid treating it as a model attribute
        params[:product].delete(:remove_images)
      end

      # Attach new images
      if params[:product][:images]
        params[:product][:images].each do |image|
          resource.images.attach(image)
        end
        params[:product].delete(:images) # Prevent overwriting existing images
      end

      super
    end
  end
end
