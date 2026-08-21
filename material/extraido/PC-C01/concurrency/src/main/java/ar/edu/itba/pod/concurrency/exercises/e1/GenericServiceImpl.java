package ar.edu.itba.pod.concurrency.exercises.e1;

/**
 * Basic implementation of {@link GenericService}.
 */
public  class GenericServiceImpl implements GenericService {

    @Override
    public String echo(String message) {
        return null;
    }

    @Override
    public String toUpper(String message) {
        return null;
    }

    @Override
    public void addVisit() {

    }

    @Override
    public int getVisitCount() {
        return 0;
    }

    @Override
    public boolean isServiceQueueEmpty() {
        return false;
    }

    @Override
    public void addToServiceQueue(String name) {

    }

    @Override
    public String getFirstInServiceQueue() {
        throw new IllegalStateException("No one in queue");
    }
}
