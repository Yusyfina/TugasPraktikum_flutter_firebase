buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Di sini tandanya sudah diganti pakai kurung () dan petik ganda "", serta komentarnya dihapus agar tidak bikin error
        classpath("com.android.tools.build:gradle:7.3.0") 
        classpath("com.google.gms:google-services:4.3.15") 
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Di bawah ini adalah kode bawaan asli dari Flutter kamu (Jangan diubah)
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}