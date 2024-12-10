# frozen_string_literal: true

ActiveAdmin.register Page do
  permit_params :title, :content

  form do |f|
    f.inputs do
      f.input :title
      f.input :content, as: :text
    end
    f.actions
  end

  show do
    attributes_table do
      row :title
      row :content do |page|
        simple_format page.content
      end
    end
  end
end
