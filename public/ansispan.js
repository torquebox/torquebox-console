var ansispan = function (str) {
  Object.keys(ansispan.foregroundColors).forEach(function (ansi) {

    //
    // `\033[Xm` == `\033[0;Xm` sets foreground color to `X`.
    //
    str = str.replace(
      new RegExp('\033\\[' + ansi + 'm', 'g'),
      '<span style="color: ' + ansispan.foregroundColors[ansi] + '">'
    ).replace(
      new RegExp('\033\\[0;' + ansi + 'm', 'g'),
      '<span style="color: ' + ansispan.foregroundColors[ansi] + '">'
    ).replace(
      new RegExp('\033\\[1;' + ansi + 'm', 'g'),
      '<span style="color: ' + ansispan.brightForegroundColors[ansi] + '">'
    ).replace( new RegExp('\033\\[4m', 'g'), '<span style="text-decoration: underline">' );
  });
  //
  // `\033[1m` enables bold font, `\033[22m` disables it or \033[0m` resets
  //
  str = str.replace(/\033\[1m/g, '<b>').replace(/\033\[22m/g, '</b>');
  str = str.replace(/\033\[1m/g, '<b>').replace(/\033\[0m/g, '</b>');


  //
  // `\033[3m` enables italics font, `\033[23m` disables it or \033[0m resets
  //
  str = str.replace(/\033\[3m/g, '<i>').replace(/\033\[23m/g, '</i>');
  str = str.replace(/\033\[3m/g, '<i>').replace(/\033\[0m/g, '</i>');

  str = str.replace(/\033\[m/g, '</span>');
  return str.replace(/\033\[39m/g, '</span>');
};

ansispan.foregroundColors = {
  '30': 'black',
  '31': 'red',
  '32': 'green',
  '33': 'yellow',
  '34': '#00bbbb',
  '35': 'purple',
  '36': 'cyan',
  '37': 'white'
};

ansispan.brightForegroundColors = {
  '30': 'black',
  '31': 'red',
  '32': 'green',
  '33': 'yellow',
  '34': '#00bbbb',
  '35': 'purple',
  '36': 'cyan',
  '37': 'white'
};

if (typeof module == "object" && typeof window == "undefined") {
  module.exports = ansispan;
}

