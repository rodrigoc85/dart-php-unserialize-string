import 'dart:convert';

class Php {
  /*
  * Translation to Dart of Nicolas Chambrier's JS implementation for unserializing PHP strings.
  * Based on https://github.com/naholyr/js-php-unserialize/blob/master/php-unserialize.js
  * */
  static Map<String, dynamic> unserialize (data) {
    Function utf8Overhead = (chr) {
      var code = chr.codeUnitAt(0);
      if (code < 0x0080) {
        return 0;
      }
      if (code < 0x0800) {
        return 1;
      }
      return 2;
    },
    error = (type, msg, [filename = "n/a", line = "n/a"]) {
      print("Error: $msg");
      print("- File: $filename");
      print("- Line: $line");
    },
    readUntil = (data, offset, stopchr) {
      var i = 2, buf = [], chr = data.substring(offset, offset + 1);
      while (chr != stopchr) {
      if ((i + offset) > data.length) {
      error('Error', 'Invalid');
      }
      buf.add(chr);
      chr = data.substring(offset + (i - 1), offset + i);
      i += 1;
      }
      return [buf.length, buf.join('')];
    },
    readChrs = (data, offset, length) {
      var i, chr, buf;

      buf = [];
      for (i = 0; i < length; i++) {
        chr = data.substring(offset + (i - 1), offset + i);
        buf.add(chr);
        length -= utf8Overhead(chr);
      }
      return [buf.length, buf.join('')];
    };

    Function _unserialize;
      _unserialize = (data, offset) {
        var dtype, dataoffset, keyandchrs, keys,
        readdata, readData, ccount, stringlength,
        i, key, kprops, kchrs, vprops, vchrs, value,
        chrs = 0,
        typeconvert = (x) {
          return x;
        },
        readArray = () {
          readdata = new Map<String, dynamic>();// = {};
          keyandchrs = readUntil(data, dataoffset, ':');
          chrs       = keyandchrs[0];
          keys       = keyandchrs[1];
          dataoffset += chrs + 2;
          int _forVal = (keys is int) ? keys : int.parse(keys);
          for (i = 0; i < _forVal; i++) {
            kprops = _unserialize(data, dataoffset);
            kchrs = kprops[1];
            key = kprops[2];
            dataoffset += kchrs;

            vprops = _unserialize(data, dataoffset);
            vchrs = vprops[1];
            value = vprops[2];
            dataoffset += vchrs;
            readdata[key] = value;
          }
        };

        if (offset == null) {
          offset = 0;
        }
        dtype = data.substring(offset, offset + 1).toLowerCase();

        dataoffset = offset + 2;

        switch (dtype) {
        case 'i':
          typeconvert = (x) {
            return x;//((x is int) ? x : int.parse(x);
          };
          readData = readUntil(data, dataoffset, ';');
          chrs = readData[0];
          readdata = "\"${readData[1]}\"";
          dataoffset += chrs + 1;
        break;
        case 'b':
          typeconvert = (x) {
            return ((x is int) ? x : int.parse(x)) != 0;
          };
          readData = readUntil(data, dataoffset, ';');
          chrs     = readData[0];
          readdata = readData[1];
          dataoffset += chrs + 1;
        break;
        case 'd':
          typeconvert = (x) {
            return (x is double) ? x : double.parse(x);
          };
          readData = readUntil(data, dataoffset, ';');
          chrs = readData[0];
          readdata = readData[1];
          dataoffset += chrs + 1;
        break;
        case 'n':
          readdata = null;
        break;
        case 's':
          ccount    = readUntil(data, dataoffset, ':');
          chrs      = ccount[0];
          stringlength = ccount[1];
          dataoffset += chrs + 2;

          readData = readChrs(data, dataoffset + 1, int.parse(stringlength));
          chrs     = readData[0];
          readdata = "\"${readData[1]}\"";
          dataoffset += chrs + 2;
          if (chrs != int.parse(stringlength) && chrs != readdata.length) {
            error('SyntaxError', 'String length mismatch');
          }
        break;
        case 'a':
          readArray();
          dataoffset += 1;
        break;
        case 'o':
          ccount = readUntil(data, dataoffset, ':');
          dataoffset += ccount[0] + 2;

          ccount = readUntil(data, dataoffset, '"');
          dataoffset += ccount[0] + 2;

          readArray();
          dataoffset += 1;
        break;
        default:
          error('SyntaxError', 'Unknown / Unhandled data type(s): ' + dtype);
        break;
      }
      return [dtype, dataoffset - offset, typeconvert(readdata)];
    };
  
    return jsonDecode(_unserialize((data + ''), 0)[2].toString());
  }
}