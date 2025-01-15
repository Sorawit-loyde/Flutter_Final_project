import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:asn1lib/asn1lib.dart';

class RSAService {
  final String publicKeyPem;

  RSAService(this.publicKeyPem);

  /// Encrypt the password using RSA-OAEP with SHA-256 and Base64 encoding
  Future<String> encryptPassword(String password) async {
    final publicKey = _importPublicKey(publicKeyPem);
    final encryptedData = _encryptWithPublicKey(password, publicKey);

    // Convert encrypted data to base64 for backend compatibility
    return base64Encode(encryptedData);
  }

  /// Parse the PEM-formatted public key and convert it to RSAPublicKey
  RSAPublicKey _importPublicKey(String pem) {
    const pemHeader = '-----BEGIN PUBLIC KEY-----';
    const pemFooter = '-----END PUBLIC KEY-----';

    // Remove PEM header, footer, and whitespace
    final pemContents = pem
        .replaceAll(pemHeader, '')
        .replaceAll(pemFooter, '')
        .replaceAll('\n', '')
        .replaceAll('\r', '');

    // Decode the Base64 string into bytes
    final derBytes = base64Decode(pemContents);

    // Parse the DER bytes into ASN.1 structure
    final asn1Parser = ASN1Parser(derBytes);
    final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

    // Extract the public key's modulus and exponent
    final publicKeyBitString = topLevelSeq.elements![1] as ASN1BitString;
    final publicKeyAsn1 = ASN1Parser(publicKeyBitString.contentBytes());
    final publicKeySeq = publicKeyAsn1.nextObject() as ASN1Sequence;

    final modulus =
        (publicKeySeq.elements![0] as ASN1Integer).valueAsBigInteger;
    final exponent =
        (publicKeySeq.elements![1] as ASN1Integer).valueAsBigInteger;

    return RSAPublicKey(modulus!, exponent!);
  }

  /// Encrypt data using the provided RSAPublicKey with RSA-OAEP and SHA-256
  Uint8List _encryptWithPublicKey(String data, RSAPublicKey publicKey) {
    // Initialize the RSA engine with OAEPEncoding and SHA-256
    final oaepEncoding = OAEPEncoding.withSHA256(RSAEngine());
    oaepEncoding.init(true, PublicKeyParameter<RSAPublicKey>(publicKey));

    // Convert the input string to bytes
    final inputBytes = Uint8List.fromList(utf8.encode(data));

    // Encrypt the data
    return oaepEncoding.process(inputBytes);
  }
}
