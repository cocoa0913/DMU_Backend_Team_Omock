import javax.servlet.annotation.WebListener;
import javax.servlet.ServletContextListener;
import javax.servlet.ServletContextEvent;
import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;

@WebListener
public class CleanupListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Context initialized: Application is starting.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        try {
            AbandonedConnectionCleanupThread.checkedShutdown();
            System.out.println("MySQL AbandonedConnectionCleanupThread stopped successfully.");
        } catch (InterruptedException e) {
            e.printStackTrace();
            System.err.println("Failed to stop AbandonedConnectionCleanupThread.");
        }
    }
}
