using GroupDocs.Redaction;
using GroupDocs.Redaction.Options;
using GroupDocs.Redaction.Options.Drawing;
using GroupDocs.Redaction.Redactions;

Console.WriteLine("======================================");
Console.WriteLine("Redact exact phrase");

// Without a license, the library runs in evaluation mode and has some limitations. 
// Output documents will contain a watermark. 
// You can request a temporary license from the GroupDocs team to evaluate the library 
// without limitations or watermarks. 
// Temporary license: https://purchase.groupdocs.com/temp-license/100492 
// Purchase a permanent license: https://purchase.groupdocs.com/buy 

//var license = new License();
//license.SetLicense("LicensePath");

// Free support: https://forum.groupdocs.com/c/redaction/33 
// Documentation: https://docs.groupdocs.com/redaction/net/

string sourceFile = "document.pdf";

using (Redactor redactor = new Redactor(sourceFile))
{
    // Hide the exact phrase "gap" with a black box
    redactor.Apply(new ExactPhraseRedaction("gap", new ReplacementOptions(Color.Black)));

    // Save the redacted document with a new name
    var saveOptions = new SaveOptions() { AddSuffix = true };
    var outputFile = redactor.Save(saveOptions);

    Console.WriteLine($"\nSource document was redacted successfully.\nFile saved to {outputFile}.\n");
}

Console.WriteLine("Redaction finished");
Console.WriteLine("======================================");