# Redacting a Phrase in a PDF on Linux

[![Product Page](https://img.shields.io/badge/Product%20Page-2865E0?style=for-the-badge&logo=appveyor&logoColor=white)](https://products.groupdocs.com/redaction/net/)
[![Docs](https://img.shields.io/badge/Docs-2865E0?style=for-the-badge&logo=Hugo&logoColor=white)](https://docs.groupdocs.com/redaction/net/)
[![Blog](https://img.shields.io/badge/Blog-2865E0?style=for-the-badge&logo=WordPress&logoColor=white)](https://blog.groupdocs.com/categories/groupdocs.redaction-product-family/)
[![Free Support](https://img.shields.io/badge/Free%20Support-2865E0?style=for-the-badge&logo=Discourse&logoColor=white)](https://forum.groupdocs.com/c/redaction/33)
[![Temporary License](https://img.shields.io/badge/Temporary%20License-2865E0?style=for-the-badge&logo=rocket&logoColor=white)](https://purchase.groupdocs.com/temp-license/100492)

# CrossplatformRedactionDockerLinux

A **GroupDocs.Redaction for .NET** sample that shows how to redact sensitive text from a PDF in a **Linux Docker container** with **.NET 10**.

The example uses `ExactPhraseRedaction` to find a phrase in a PDF and cover every match with a **black box**. It also shows the Linux dependencies required for text rendering and redaction in a minimal Docker image.

## What This Example Shows

This sample demonstrates how to:

* redact an exact phrase from a PDF;
* apply a black box with `ReplacementOptions(Color.Black)`;
* run **GroupDocs.Redaction for .NET** in a Linux Docker container;
* configure native libraries and fonts required for PDF text rendering;
* save the redacted document as `document_Redacted.pdf`.

The sample uses **GroupDocs.Redaction 26.9.0** and targets **.NET 10 (`net10.0`)**.

## Why the Docker Image Needs Extra Dependencies

The base `mcr.microsoft.com/dotnet/runtime:10.0` image does not include all native libraries and fonts required by the redaction example on Linux.

The `Dockerfile` installs the dependencies used by the application:

* `fontconfig` and `libfreetype6` for font discovery and text handling;
* `libgdiplus` and `libx11-dev` for graphics and rendering support;
* `libc6-dev` and the `libdl.so` compatibility link required by the Linux runtime;
* `ttf-mscorefonts-installer` and `fonts-lato` to provide the fonts used by the rendering environment.

It also updates the font cache after installing the fonts. With these dependencies in the container, `ExactPhraseRedaction` can create the black box redaction when processing the PDF on Linux.

## Prerequisites

* **.NET SDK 10.0**
* **Docker Desktop**
* **GroupDocs.Redaction for .NET 26.9.0** — restored from NuGet
* **License file** — optional. Without a license, the sample runs in evaluation mode.

## Project Structure

```text
CrossplatformRedactionDockerLinux/
│
├── Program.cs
├── CrossplatformRedactionDockerLinux.csproj
├── CrossplatformRedactionDockerLinux.slnx
├── Dockerfile
├── document.pdf
└── document_Redacted.pdf
```

* `Program.cs` — opens the source PDF, redacts text, and saves the result.
* `CrossplatformRedactionDockerLinux.csproj` — targets `net10.0` and references GroupDocs.Redaction 26.9.0.
* `Dockerfile` — builds the Linux container and installs the required native libraries and fonts.
* `document.pdf` — input PDF used by the sample.
* `document_Redacted.pdf` — output PDF created after a successful save.

## Code Example

### Redact an exact phrase with a black box

`ExactPhraseRedaction` searches for the specified phrase. The search is case-insensitive by default. Pass `true` as the middle argument to enable case-sensitive matching.

`ReplacementOptions(Color.Black)` replaces the matched text visually with a solid black rectangle instead of replacement text.

```csharp
using GroupDocs.Redaction;
using GroupDocs.Redaction.Options;
using GroupDocs.Redaction.Options.Drawing;
using GroupDocs.Redaction.Redactions;

using (Redactor redactor = new Redactor("document.pdf"))
{
    redactor.Apply(new ExactPhraseRedaction("gap", new ReplacementOptions(Color.Black)));

    var saveOptions = new SaveOptions() { AddSuffix = true };
    var outputFile = redactor.Save(saveOptions);
}
```

`AddSuffix = true` saves the result as `document_Redacted.pdf`.

`RasterizeToPDF` remains `false` by default, so the sample saves the document without rasterizing its pages.

Check the result returned by `Apply` before treating the output as successfully redacted. `Save` can still create an output file when a redaction fails, so the output should only be used when the redaction status confirms that the rule was applied.

## Run the Sample

Place `document.pdf` in the project directory before running the sample.

### Visual Studio

1. Open `CrossplatformRedactionDockerLinux.slnx`.
2. Select **Container (Dockerfile)** as the startup profile.
3. Press **F5** to debug or **Ctrl+F5** to run without debugging.

The first run builds the Linux Docker image and installs the required native libraries and fonts. Subsequent runs can reuse the existing image.

Visual Studio mounts the project directory into the container. The generated `document_Redacted.pdf` therefore appears in the project directory next to `document.pdf`.

The **CrossplatformRedactionDockerLinux** profile runs the application directly on the host and does not use the Docker image.

### Docker Command Line

From the project directory, build the image:

```bash
docker build -t crossplatform-redaction .
```

Run the sample:

```bash
docker run --rm -v "${PWD}:/data" -w /data --entrypoint dotnet crossplatform-redaction /app/CrossplatformRedactionDockerLinux.dll
```

The project directory is mounted at `/data` and used as the container's working directory. The application reads `document.pdf` from `/data` and writes `document_Redacted.pdf` back to the mounted project directory.

On Windows PowerShell, `${PWD}` expands to the current working directory. Run the commands from the project directory.

## Related Documentation

* **[Text redaction](https://docs.groupdocs.com/redaction/net/text-redactions/)** — exact phrase matching, case-sensitive search, and colored box redaction.
* **[Redaction basics](https://docs.groupdocs.com/redaction/net/redaction-basics/)** — redaction results and `Applied`, `Skipped`, and `Failed` statuses.
* **[Save in the original format](https://docs.groupdocs.com/redaction/net/save-in-original-format/)** — how `SaveOptions` works when PDF rasterization is disabled.
* **[System requirements](https://docs.groupdocs.com/redaction/net/system-requirements/)** — supported operating systems and .NET versions.
* **[Evaluation and licensing](https://docs.groupdocs.com/redaction/net/evaluation-limitations-and-licensing/)** — evaluation mode and license requirements.
* **[Migration notes for 26.9](https://docs.groupdocs.com/redaction/net/migration-notes/)** — changes to the drawing API and `GroupDocs.Redaction.Options.Drawing`.
* **[GroupDocs.Redaction for .NET 26.9 release notes](https://releases.groupdocs.com/redaction/net/release-notes/2026/groupdocs-redaction-for-net-26-9-release-notes/)** — changes introduced in version 26.9.
