// =============================================================================
//
//          FILE: form.js
//
//         USAGE: ---
//   DESCRIPTION: This file provides functions to generate the input form and
//                handle the submitted data.
//
//       OPTIONS: ---
//  REQUIREMENTS: ---
//          BUGS: ---
//         NOTES: ---
//        AUTHOR: Fabian Eberts
//  ORGANIZATION: ---
//       CREATED: ---
//      REVISION: ---
//
// =============================================================================

const placeholder_map = new Map();
let placeholders_found = true;

/*
 * print form for entering placeholders
 */
function print_form()
{
    document.write('<form action="javascript:form_handler()">');

    // generate input fields:
    for(const ph of placeholders)
    {
        if(/^[^+]+\+$/.test(ph)) // text area input
        {
            console.log("form: textarea");
            let ph_text = ph.replaceAll('+', ''); // remove special character
            document.write('<textarea name="' + ph + '" rows="5" cols="50">' + ph_text + '</textarea><br><br>');
        }
        else // line input
        {
            console.log("form: text");
            document.write('<input type="text" name="' + ph + '" value="' + ph + '" size="50" required><br><br>');
        }
    }

    document.write('<input type="submit" value="Weiter">');
    document.write('</form>');
}

/*
 * read form data and store it in a map, then load the code editor
 */
function form_handler()
{
    for(const ph of placeholders)
    {
        placeholder_map.set(ph, document.getElementsByName(ph)[0].value);
    }

    load_editor();
}

/*
 * remove form from DOM and load editor
 */
function load_editor()
{
    document.getElementById("form").remove();
    init();
}
