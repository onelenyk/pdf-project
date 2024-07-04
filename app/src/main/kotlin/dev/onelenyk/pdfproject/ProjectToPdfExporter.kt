package dev.onelenyk.pdfproject

import com.itextpdf.html2pdf.HtmlConverter
import com.itextpdf.kernel.pdf.PdfDocument
import com.itextpdf.kernel.pdf.PdfReader
import com.itextpdf.kernel.pdf.PdfWriter
import com.itextpdf.kernel.utils.PdfMerger
import dev.onelenyk.FileProcessor
import dev.onelenyk.IFileProcessor
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.nio.file.Path

class ProjectToPdfExporter(
    private val rootDirectory: Path,
    customRules: List<String> = listOf(),
) {
    private val fileProcessor: IFileProcessor =
        FileProcessor(
            rootDirectory,
            customRules = customRules,
        )

    private val outputFilePath: String = "$rootDirectory/output.pdf"
    private val temporaryDirectoryPath: String = "$rootDirectory/exporter"

    fun executeConversion() {
        println("Starting conversion...")
        convertProjectToHTML()
        compileHTMLToPDF()
        println("Conversion completed.")
    }

    private fun convertProjectToHTML() {
        setupTemporaryDirectory()

        val filesToProcess = fileProcessor.process()
        println("Converting files to HTML...")

        filesToProcess.forEachIndexed { index, file ->
            val relativePath = rootDirectory.parent.resolve(file)
            val htmlFilePath = "$temporaryDirectoryPath/$file.html"
            File(htmlFilePath).apply {
                parentFile.mkdirs()
                writeText(convertFileToHTML(relativePath.toFile()))
            }
            println("Converted [${index + 1}/${filesToProcess.size}] files to HTML.")
        }
    }

    private fun compileHTMLToPDF() {
        val htmlFiles = findHtmlFiles()
        println("Compiling HTML files into PDF... Total files: ${htmlFiles.size}")

        val tempPdfFiles = convertHtmlToPdf(htmlFiles)

        println("HTML to PDF conversion completed. Merging PDF files...")
        mergePdfFiles(tempPdfFiles)

        cleanUpTemporaryFiles(tempPdfFiles)
        println("Compiled HTML to PDF successfully. Output file: $outputFilePath")
    }

    private fun setupTemporaryDirectory() {
        File(temporaryDirectoryPath).apply {
            if (exists()) deleteRecursively()
            mkdirs()
        }
    }

    private fun findHtmlFiles(): List<File> =
        File(temporaryDirectoryPath)
            .listFiles()
            ?.flatMap { it.walk().filter { file -> file.extension == "html" } }
            .orEmpty()

    private fun convertHtmlToPdf(htmlFiles: List<File>): List<File> =
        htmlFiles.mapIndexed { index, htmlFile ->
            println("Converting HTML to PDF: ${index + 1}/${htmlFiles.size} (${htmlFile.name})")
            File(temporaryDirectoryPath, "temp_$index.pdf").apply {
                HtmlConverter.convertToPdf(FileInputStream(htmlFile), FileOutputStream(this))
                htmlFile.delete() // Consider deleting this line if you want to keep HTML files for review.
            }
        }

    private fun mergePdfFiles(tempPdfFiles: List<File>) {
        PdfDocument(PdfWriter(outputFilePath)).use { finalPdf ->
            val pdfMerger = PdfMerger(finalPdf)
            tempPdfFiles.forEachIndexed { index, tempPdfFile ->
                println("Merging PDF file ${index + 1} of ${tempPdfFiles.size}")
                PdfDocument(PdfReader(tempPdfFile.absolutePath)).use { tempPdfDocument ->
                    pdfMerger.merge(tempPdfDocument, 1, tempPdfDocument.numberOfPages)
                }
                tempPdfFile.delete() // Ensure temporary PDF files are cleaned up after merging.
            }
        }
        println("All PDF files have been merged into $outputFilePath")
    }

    private fun cleanUpTemporaryFiles(tempPdfFiles: List<File>) {
        tempPdfFiles.forEach(File::delete)
        File(temporaryDirectoryPath).deleteRecursively()
    }

    private fun convertFileToHTML(file: File): String {
        val fileContent = file.readText(Charsets.UTF_8)
        return "<html><body><pre><code>${escapeHtml(fileContent)}</code></pre></body></html>"
    }

    private fun escapeHtml(text: String): String =
        text.replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
}
