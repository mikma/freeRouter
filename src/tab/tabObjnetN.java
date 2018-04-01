package tab;

import addr.addrPrefix;
import addr.addrType;
import java.util.ArrayList;
import java.util.List;
import pack.packHolder;

/**
 * represents one network object group entry
 *
 * @param <T> type of address
 * @author matecsaba
 */
public class tabObjnetN<T extends addrType> extends tabListingEntry<T> {

    /**
     * source address
     */
    public T addr;

    /**
     * source mask
     */
    public T mask;

    /**
     * create new object group entry
     *
     * @param adr empty address to use
     */
    @SuppressWarnings("unchecked")
    public tabObjnetN(T adr) {
        addr = (T) adr.copyBytes();
        mask = (T) adr.copyBytes();
    }

    /**
     * convert string to address
     *
     * @param s string to convert
     * @return true if error happened
     */
    public boolean fromString(String s) {
        action = tabPlcmapN.actionType.actPermit;
        s = s.trim() + " ";
        int i = s.indexOf(" ");
        String a = s.substring(0, i).trim();
        s = s.substring(i, s.length()).trim();
        if (addr.fromString(a)) {
            return true;
        }
        if (mask.fromString(s)) {
            return true;
        }
        addr.setAnd(addr, mask);
        return false;
    }

    public String toString() {
        return addr + " " + mask;
    }

    public List<String> usrString(String beg) {
        List<String> l = new ArrayList<String>();
        l.add(beg + "sequence " + sequence + " " + this);
        return l;
    }

    public boolean matches(int afi, addrPrefix<T> net) {
        return false;
    }

    public boolean matches(int afi, tabRouteEntry<T> net) {
        return false;
    }

    public boolean matches(packHolder pck) {
        if (!pck.IPsrc.isMatches(addr, mask)) {
            return false;
        }
        return true;
    }

    public void update(int afi, tabRouteEntry<T> net) {
    }

}