package dev.onelenyk.pdfproject

import picocli.CommandLine
import java.nio.file.Paths
import java.util.concurrent.Callable

@CommandLine.Command(
    name = "pdfproject",
    mixinStandardHelpOptions = true,
    version = ["pdfproject 1.0"],
    description = ["A command-line tool to convert any project to a PDF document."],
)
class App : Callable<Int> {
    @CommandLine.Option(names = ["-p", "--projectRoot"], description = ["Path to the project root"], required = true)
    lateinit var projectRoot: String

    @CommandLine.Option(names = ["-r", "--rules"], description = ["Custom rules for filtering files"], split = ",")
    var customRules: List<String> = defaultRules

    override fun call(): Int {
        val projectRootPath = Paths.get(projectRoot).toAbsolutePath()
        val converter =
            ProjectToPdfExporter(
                projectRootPath,
                customRules = customRules,
            )
        converter.executeConversion()
        return 0
    }

    companion object {
        val defaultRules =
            listOf(
                ".*\\.idea(/|$)",
                ".*\\.git(/|$)",
                ".*\\.jar$",
                ".*\\.DS_Store",
                ".*\\.pdf$",
                ".*\\.bat$",
            )
    }
}

fun main(args: Array<String>) {
    val exitCode = CommandLine(App()).execute(*args)
    System.exit(exitCode)
}
