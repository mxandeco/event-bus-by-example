package events.template;

import ie.dsch.events.client.EventBus;
import ie.dsch.events.client.config.Options;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class TemplateMain {

  private static final Logger log = LoggerFactory.getLogger(TemplateMain.class);

  public static void main(String[] args) {

    Options options = Options.local();

    EventBus bus = EventBus.create(options);

  }

}
