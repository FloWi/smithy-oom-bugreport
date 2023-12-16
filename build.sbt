import smithy4s.codegen.Smithy4sCodegenPlugin

ThisBuild / scalaVersion := "2.13.12"

val example = project
  .in(file("modules/example"))
  .enablePlugins(Smithy4sCodegenPlugin)
  .settings(
    libraryDependencies ++= Seq(
      "com.disneystreaming.smithy4s" %% "smithy4s-http4s" % smithy4sVersion.value,
      "com.disneystreaming.smithy4s" %% "smithy4s-http4s-swagger" % smithy4sVersion.value,
      "org.http4s" %% "http4s-ember-server" % "0.23.23",
      "io.circe" %% "circe-generic" % "0.15.0-M1",
      "io.circe" %% "circe-parser" % "0.15.0-M1",

    )
  )
