

const engine = new PdfTeXEngine();

// const template_name = "Hallo LaTeX";
// const main_tex_file = "hello_latex.tex";
// const files = ["hello_latex.tex","troll.jpg","zweitedatei.tex",];
// const placeholders = [];

async function add_files_to_engine()
{
    console.log("add files to engine:");
    
    for(const file of files)
    {
        await add_file_to_engine(file);
    }
    
    await engine.setEngineMainFile(main_tex_file);
    console.log(main_tex_file + " set as main file");
}

async function add_file_to_engine(filename)
{
    if(/^.+\.(tex|bib|sty|cls)$/.test(filename))
    {
        await add_text(filename);
        console.log(filename + " added as text");
    }
    else
    {
        await add_image(filename);
        console.log(filename + " added as image");
    }
}

async function add_text(filename)
{
    let raw = await fetch(filename);
    let text = await raw.text();
    engine.writeMemFSFile(filename, text);
}

async function add_image(filename)
{
    let raw = await fetch(filename);
    let blob = await raw.arrayBuffer();
    engine.writeMemFSFile(filename, new Uint8Array(blob));
}

async function compile()
{
    // PdfTeXEngine laden:
    console.log("loading engine");
    await engine.loadEngine();

    // TeXLive-On-Demand-Server setzen:
    console.log("setting TexLive endpoint");
    engine.setTexliveEndpoint("http://tex.feb-dev.net:4711/");
    if(!engine.isReady()) { console.log("engine is not ready"); return; }
    console.log("engine is ready");

    // TeX-Datei angeben:
    await add_files_to_engine();

    // kompilieren:
    console.log("compiling document");
    let result = await engine.compileLaTeX();
    result = await engine.compileLaTeX();
    result = await engine.compileLaTeX();
    result = await engine.compileLaTeX();
    result = await engine.compileLaTeX();
    console.log(result.log);

    // PDF anzeigen:
    console.log("displaying pdf");
    const pdfblob = new Blob([result.pdf], {type : 'application/pdf'});
    const objectURL = URL.createObjectURL(pdfblob);
    setTimeout(()=>{URL.revokeObjectURL(objectURL);}, 30000);
    const pdfViewer = document.getElementById("pdfViewer");
    pdfViewer.innerHTML = `<embed src="${objectURL}" style="position: absolute; height: 100%; width: 100%;" type="application/pdf">`;
}
