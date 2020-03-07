#include <example-module/example-module.h>

#include <QApplication>

#include <iostream>

// Controls the console window display
#ifdef NDEBUG
#pragma comment(linker, "/SUBSYSTEM:windows /ENTRY:mainCRTStartup")
#endif



int main( int argc, char** argv ){

	QApplication::setAttribute(Qt::AA_EnableHighDpiScaling); // helps window to scale with high dpi displays

	QApplication a( argc, argv );
	// set names so QSettings places entries in correct registry locations
	// track application name w/ version number
	a.setApplicationName( "example-application" );
	a.setOrganizationName( QStringLiteral("organization name") );

#ifdef Q_OS_WIN
	a.setAttribute( Qt::AA_UseOpenGLES );
#endif

	int returnCode = 0;
	try{
		example_module::ExampleClass(nullptr);
		returnCode = a.exec();
	} catch( std::exception& e ){
		std::cerr << e.what() << std::endl;
	}
	return returnCode;
}
