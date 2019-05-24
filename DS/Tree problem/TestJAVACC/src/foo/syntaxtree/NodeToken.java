/* Generated by JTB 1.4.11 */
package foo.syntaxtree;

import foo.visitor.IRetArguVisitor;
import foo.visitor.IRetVisitor;
import foo.visitor.IVoidArguVisitor;
import foo.visitor.IVoidVisitor;
import java.util.*;

public class NodeToken implements INode {

  public String tokenImage;

  public List<NodeToken> specialTokens;

  public int beginLine;

  public int beginColumn;

  public int endLine;

  public int endColumn;

  public int kind;

  private static final long serialVersionUID = 1411L;

  public static final String LS = System.getProperty("line.separator");

  public NodeToken(final String s) {
    this(s, -1, -1, -1, -1, -1);
  }

  public NodeToken(final String s, final int kn, final int bl, final int bc, final int el, final int ec) {
    tokenImage = s;
    specialTokens = null;
    kind = kn;
    beginLine = bl;
    beginColumn = bc;
    endLine = el;
    endColumn = ec;
  }

  public NodeToken getSpecialAt(final int i) {
    if (specialTokens == null)
      throw new NoSuchElementException("No specialTokens in token");
    return specialTokens.get(i);
  }

  public int numSpecials() {
    if (specialTokens == null)
      return 0;
    return specialTokens.size();
  }

  public void addSpecial(final NodeToken s) {
    if (specialTokens == null)
      specialTokens = new ArrayList<NodeToken>();
    specialTokens.add(s);
  }

  public void trimSpecials() {
    if (specialTokens == null)
      return;
    ((ArrayList<NodeToken>) specialTokens).trimToSize();
  }

  @Override
  public String toString() {
    return tokenImage;
  }

  public String getSpecials(final String spc) {
    if (specialTokens == null)
      return "";
    int stLastLine = -1;
    final StringBuilder buf = new StringBuilder(64);
    boolean hasEol = false;
    for (final Iterator<NodeToken> e = specialTokens.iterator(); e.hasNext();) {
      final NodeToken st = e.next();
      final char c = st.tokenImage.charAt(st.tokenImage.length() - 1);
      hasEol = c == '\n' || c == '\r';
      if (stLastLine != -1)
        // not first line 
        if (stLastLine != st.beginLine)
          // if not on the same line as the previous
          buf.append(spc);
        else
          // on the same line as the previous
          buf.append(' ');
      buf.append(st.tokenImage);
      if (!hasEol && e.hasNext()) {
        // not a single line comment and not the last one
        buf.append(LS);
      }
      stLastLine = st.endLine;
    }
    // keep the same number of blank lines before the current non special
    for (int i = stLastLine + (hasEol ? 1 : 0); i < beginLine; i++) {
      buf.append(LS);
      if (i != beginLine - 1)
        buf.append(spc);
    }
    // indent if the current non special is not on the same line
    if (stLastLine != beginLine)
      buf.append(spc);
    return buf.toString();
  }
  public String withSpecials(final String spc) {
    return withSpecials(spc, null);
  }

  public String withSpecials(final String spc, final String var) {
    final String specials = getSpecials(spc);
    int len = specials.length();
    if (len == 0)
      return (var == null ? tokenImage : var + tokenImage);
    if (var != null)
      len += var.length();
    StringBuilder buf = new StringBuilder(len + tokenImage.length());
    buf.append(specials);
  // see if needed to add a space
  int stLastLine = -1;
  for (final Iterator<NodeToken> e = specialTokens.iterator(); e.hasNext();) {
    stLastLine = e.next().endLine;
  }
  if (stLastLine == beginLine)
    buf.append(' ');
  if (var != null)
    buf.append(var);
  buf.append(tokenImage);
    return buf.toString();
  }

  @Override
  public <R, A> R accept(final IRetArguVisitor<R, A> vis, final A argu) {
    return vis.visit(this, argu);
  }

  @Override
  public <R> R accept(final IRetVisitor<R> vis) {
    return vis.visit(this);
  }

  @Override
  public <A> void accept(final IVoidArguVisitor<A> vis, final A argu) {
    vis.visit(this, argu);
  }

  @Override
  public void accept(final IVoidVisitor vis) {
    vis.visit(this);
  }

}
