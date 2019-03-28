public with sharing class SFG_Logger {


    private static String MESSAGE_SUFFIX = ': ';


    public SFG_Logger(String className) {

        this.writer = new SystemDebugLogWriter(className);
    }


    public SFG_Logger(System.Type classType){

        this(classType.getName());
    }


    public SFG_Logger(LogWriter writer){
        this.writer = writer;
    }


    public void debug(String message, Object value){

        write(LoggingLevel.DEBUG, message, value);
    }


    public void info(String message, Object value){

        write(LoggingLevel.INFO, message, value);
    }


    public void warn(String message, Object value){

        write(LoggingLevel.WARN, message, value);
    }


    public void error(String message, Object value){

        write(LoggingLevel.ERROR, message, value);
    }


    public void error(String message, Exception e){

        error(message, e.getMessage());
        Exception cause = e.getCause();
        if(cause != null){
            debug(message, 'cause message: ' + cause.getMessage());
        }
        debug(message, e.getStackTraceString());
    }


    public void error(Exception e){

        error('', e);
    }


    public EnterMethod enterMethod(String methodName){

        return new EnterMethod(methodName, this.writer);
    }


    public ExitMethod exitMethod(String methodName){

        return new ExitMethod(methodName, this.writer);
    }


    private void write(LoggingLevel level, String message, Object value){

        this.writer.write(level, message + MESSAGE_SUFFIX + value);
    }



    public class EnterMethod{

        public EnterMethod(String methodName, LogWriter writer){

            this.methodName = methodName;
            this.writer = writer;
            this.writer.write('Entering method ' + methodName);
        }

        public EnterMethod param(String name, Object value){

            this.writer.write('param name=' + name + ', value=' + String.valueOf(value));
            return this;
        }


        private String methodName;
        private LogWriter writer;
    }



    public class ExitMethod{

        public ExitMethod(String methodName, LogWriter writer){

            this.methodName = methodName;
            this.writer = writer;
            this.writer.write('Exiting method ' + methodName);
        }

        public void withResult(Object result){

            this.writer.write('with result' + MESSAGE_SUFFIX + String.valueOf(result));
        }

        private String methodName;
        private LogWriter writer;
    }

    public Interface LogWriter{
        
        void write(Object logEntry);

        void write(LoggingLevel level, Object logEntry);
    }


    private class SystemDebugLogWriter
        implements LogWriter{

        public SystemDebugLogWriter(String className){

            this.className = className;
        }

        public void write(Object logEntry){

            write(LoggingLevel.DEBUG, logEntry);
        }

        public void write(LoggingLevel level, Object logEntry){

            System.debug(level, className + MESSAGE_SUFFIX + String.valueOf(logEntry));
        }

        private String className;
    }

    @testVisible
    private LogWriter writer;
}