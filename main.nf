#!/usr/bin/env nextflow

// Parameter to optionally trigger pipeline failure for testing
params.trigger_failure = false

process sayHello {
    input:
    val x

    output:
    stdout

    script:
    """
    echo '${x} world!'
    """
}

process failOnPurpose {
    when:
    params.trigger_failure

    script:
    """
    echo "Triggering intentional failure for testing..."
    exit 1
    """
}

workflow {
    Channel.of('Bonjour', 'Ciao', 'Hello', 'Hola') | sayHello | view
    
    // Optionally trigger failure for testing
    if (params.trigger_failure) {
        failOnPurpose()
    }
}
workflow.onError { err ->
    println "=================================================="
    println "Pipeline encountered an error!"
    println "Error message: ${err.message}"
    println "Please review the error and take necessary actions."
    println "=================================================="
}

workflow.onComplete {
    def status = workflow.success ? "SUCCESS" : "FAILED"
    
    println "=================================================="
    println "Pipeline execution summary"
    println "=================================================="
    println "Pipeline status   : ${status}"
    println "Pipeline name     : ${workflow.manifest.name ?: workflow.scriptName}"
    println "Run name          : ${workflow.runName}"
    println "Session ID        : ${workflow.sessionId}"
    println "Start time        : ${workflow.start}"
    println "Complete time     : ${workflow.complete}"
    println "Duration          : ${workflow.duration}"
    println "Exit status       : ${workflow.exitStatus}"
    println "Error message     : ${workflow.errorMessage ?: 'None'}"
    println "Error report      : ${workflow.errorReport ?: 'None'}"
    println "Command line      : ${workflow.commandLine}"
    println "Work directory    : ${workflow.workDir}"
    println "Launch directory  : ${workflow.launchDir}"
    println "=================================================="
    
    if (workflow.success) {
        println "✅ Pipeline completed successfully!"
    } else {
        println "❌ Pipeline execution failed!"
        println "Please check the error message and report above."
    }
    println "=================================================="
}
