import QRCode
import Tafelsalz

// <#FIXME#> Remove Android workaround (Todo-iOS/#2)
let MASTER_KEY_PREFIX = "PLIB"
let MASTER_KEY_PREFIX_SIZE_IN_BYTES = MASTER_KEY_PREFIX.utf8Bytes.count

extension MasterKey {

	/**
		Export the master key as a QR Code. The value is Base64-encoded.

		- returns:
			The QR Code.
	*/
	public func qrCode() -> QRCode {
		assert(self.sizeInBytes <= QRCode.MaximumSizeInBytes)
		assert(MASTER_KEY_PREFIX_SIZE_IN_BYTES + base64EncodedString().lengthOfBytes(using: .isoLatin1) <= QRCode.MaximumSizeInBytes)

		return QRCode(MASTER_KEY_PREFIX + base64EncodedString())!
	}

	/**
		Export the master key as a Base64-encoded string.

		- returns:
			The Base64-encoded representation of the master key.
	*/
	public func base64EncodedString() -> String {
		return copyBytes().b64encode()
	}

	/**
		Initialize a master key from a Base64-encoded string.

		- parameters:
			- base64Encoded: The Base64-encoded representation of a master key.

		- returns:
			`nil` if `base64Encoded` is not a valid.
	*/
	public convenience init?(base64Encoded encodedString: String) {
		var string = encodedString
		if string.starts(with: MASTER_KEY_PREFIX) {
			string.removeFirst(MASTER_KEY_PREFIX_SIZE_IN_BYTES)
		}

		guard var bytes = string.b64decode() else {
			return nil
		}

		self.init(bytes: &bytes)
	}

}
