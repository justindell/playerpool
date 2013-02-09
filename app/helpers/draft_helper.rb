module DraftHelper
  # duplicated in draft.js
  COLOR_MAP = {
    1 => 'blue', 2 => 'red', 3 => 'green', 4 => 'brown',
    5 => 'darkorange', 6 => 'purple', 7 => 'olive', 8 => 'firebrick',
    9 => 'darkslateblue', 10 => 'dimgray', 11 => 'coral', 12 => 'darkolivegreen'
  }

  def color_for_user user
    COLOR_MAP[user % 12]
  end
end
