package ar.edu.itba.pod.concurrency.iii.inmutable;

import java.util.Date;
import java.util.List;

public class Subscriber {
    private  Integer id;
    private  String fullName;
    private  Date dateOfBirth;
    private  List<Subscription> subscriptions;

    public Subscriber(Integer id, String fullName, Date dateOfBirth,  List<Subscription> subscriptions) {
        this.id = id;
        this.fullName = fullName;
        this.dateOfBirth = dateOfBirth;
        this.subscriptions = subscriptions;
    }

    public Integer getId() {
        return id;
    }

    public String getFullName() {
        return fullName;
    }

    public Date getDateOfBirth() {
        return dateOfBirth;
    }

    public List<Subscription> getSubscriptions() {
        return subscriptions;
    }
}
