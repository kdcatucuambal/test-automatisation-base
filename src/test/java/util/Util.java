package util;

public class Util {

    public static String getRandomName() {
        String[] names = {"Alice", "Bob", "Charlie", "Diana", "Ethan"};
        int randomIndex = (int) (Math.random() * names.length);
        var name = names[randomIndex];
        var unixTime = System.currentTimeMillis() / 1000L;
        return  name + unixTime;
    }

}