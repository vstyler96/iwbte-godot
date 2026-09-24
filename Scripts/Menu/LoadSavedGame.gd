extends Control

@onready var hoverSound = preload("res://Sounds/SFX/DJump.wav")
@onready var theme_ui = preload("res://Rooms/Menu/UI/UI.tres")

var confirm = ConfirmationDialog.new()
var pendingDelete: Control
var pendingIndex: int

func _ready():
  $Menu.visible = false;
  $EmptyState.visible = true;
  confirm.theme = theme_ui
  confirm.confirmed.connect(self._on_delete_confirmed)
  add_child(confirm)

  if Env.settings.slots.size() > 0:
    $Menu.visible = true;
    $EmptyState.visible = false;

    for index in Env.settings.slots:
      var row = HBoxContainer.new()
      var slotName = Storage.readEncrypted("user://%s.sav" % index).get("name", "Slot (%s)" % index)

      var button = Button.new()
      button.theme = theme_ui
      button.text = slotName
      button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
      button.pressed.connect(self.loadSlot.bind(index))
      button.mouse_entered.connect(self._on_button_mouse_entered)
      row.add_child(button)

      var delete = Button.new()
      delete.theme = theme_ui
      delete.text = "Delete"
      delete.pressed.connect(self.askDelete.bind(index, slotName, row))
      delete.mouse_entered.connect(self._on_button_mouse_entered)
      row.add_child(delete)

      $Menu/VBoxContainer.add_child(row)


func loadSlot(index: int):
  Env.loadSlot(index)
  get_tree().change_scene_to_file("res://Rooms/GamePlay/%s.tscn" % Env.slot.room)

func askDelete(index: int, slotName: String, row: Control):
  pendingIndex = index
  pendingDelete = row
  confirm.dialog_text = "Delete %s? This can't be undone." % slotName
  confirm.popup_centered()

func _on_delete_confirmed():
  Env.deleteSlot(pendingIndex)
  pendingDelete.queue_free()

  if Env.settings.slots.is_empty():
    $Menu.visible = false
    $EmptyState.visible = true

func _on_button_pressed():
  get_tree().change_scene_to_file("res://Rooms/Menu/Menu.tscn")

func _on_button_mouse_entered():
  var audio = AudioStreamPlayer2D.new()
  audio.stream = hoverSound;
  audio.bus = "SFX"
  add_child(audio)
  audio.play()
