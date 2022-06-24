defmodule TodoWeb.ItemsView do
  use TodoWeb, :view

  def error_message({attr, {message, _}}) do
    "#{attr}: #{message}"
  end

  def prepare_styles do
    "animation-duration: #{ Enum.random(0..30) + 15 }s, #{ Enum.random(0..30) + 15 }s;"
  end

  def prepare_classes(item) do
    case item.completed do
      true -> 'item completed'
      false -> 'item incompleted'
    end
  end

  def prepare_moving_item_classes(item) do
    "moving-item moving-item-#{ rem(item.id, 4) + 1 }"
  end
end
