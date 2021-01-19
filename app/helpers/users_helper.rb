module UsersHelper

  # 引数で与えられたユーザーのアイコン画像を返す
  def icon_image(user, add_class: '')
    if user.image.attached?
      icon = user.display_icon
    else
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      icon = "https://secure.gravatar.com/avatar/#{gravatar_id}"
      # gravatar_url, alt: user.name, class: "rounded-circle #{add_class}"
    end
    image_tag(icon, alt: user.name, class: "rounded-circle #{add_class}")
  end
end
