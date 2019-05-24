/* Generated by JTB 1.4.11 */
package foo.syntaxtree;

import foo.visitor.IRetArguVisitor;
import foo.visitor.IRetVisitor;
import foo.visitor.IVoidArguVisitor;
import foo.visitor.IVoidVisitor;

public class NodeOptional implements INode {

  public INode node;

  private static final long serialVersionUID = 1411L;

  public NodeOptional() {
    node = null;
  }

  public NodeOptional(final INode n) {
    addNode(n);
  }

  public void addNode(final INode n) {
    if (node != null)
      throw new Error("Attempt to set optional node twice");
    node = n;
  }

  public boolean present() {
    return (node != null); }

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
