extends Node
class_name Cipher

var aes: AESContext = AESContext.new()
var key = "qeDvENKGjDlnTfs7"
var iv = "qNJlk1msvXU18SyG"

func encrypt(data: String) -> String:
  aes.start(
    AESContext.MODE_CBC_ENCRYPT,
    key.to_utf8_buffer(),
    iv.to_utf8_buffer()
  );
  var encrypted = aes.update(data.to_utf8_buffer())
  aes.finish()
  return encrypted.get_string_from_utf8()

func decrypt(data: String) -> String:
  aes.start(
    AESContext.MODE_CBC_DECRYPT,
    key.to_utf8_buffer(),
    iv.to_utf8_buffer()
  )
  var decrypted = aes.update(data.to_utf8_buffer())
  aes.finish()
  return decrypted.get_string_from_utf8()
