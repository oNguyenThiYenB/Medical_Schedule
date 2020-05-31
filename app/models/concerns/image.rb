module Image
  def attach_image params, call_object
    if params[call_object][:image].blank?
      check_create params[:action]
    else
      image.attach params[call_object][:image]
    end
  end

  def check_create params
    return true unless params.eql? "create"

    image.attach(io: File.open(Rails.root
      .join("app/assets/images/default_avatar.png")),
      filename: "default_avatar.png")
  end

  def attach_file params
    files.purge
    files.attach params[:patient][:files]
  end

  def attach_article_image params
    if params[:article][:images].blank?
      check_create_article params[:action]
    else
      images.purge
      images.attach(params[:article][:images])
    end
  end

  def check_create_article params
    return true unless params.eql? "create"

    images.attach(io: File.open(Rails.root
      .join("app/assets/images/blog1.jpg")),
      filename: "blog1.jpg")
  end
end
