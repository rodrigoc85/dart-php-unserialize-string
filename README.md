
# dart-php-unserialize-string  
This is a Dart (for Flutter) translation of Nicolas Chambrier's javascript implementation to unserialize PHP strings.

Given a [serialized string in php](https://www.php.net/manual/es/function.serialize.php), translates and returns a Map<String, dynamic> object.

Usage:
````
String _sample = 'O:8:"stdClass":5:{s:4:"name";s:7:"Rodrigo";s:4:"last";s:7:"Cardozo";s:3:"age";i:35;s:9:"developer";b:1;s:6:"height";d:73.5;}';

var object = Php.unserialize(_sample);  

print(object["name"]);
````
