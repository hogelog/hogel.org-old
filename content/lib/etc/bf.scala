import java.lang.System
import java.io.InputStream
import java.util.Vector
object BFi{
	val out = System.out
	val in = System.in
	val mem = Array[Int]
	val offset = Int
	class Exp(c: Int){
		val code = c
	}
	class Block(c: Int) extends Exp(c: Int){
		val exps = new Vector
		val code = c;
		def add(exp: Exp): Block = {
			exps.addElement(exp)
			return this
		}
		def eval(i: Int){
			val code = exps.elementAt(i)
			if(code=='+'){
				mem[offset] += 1
			}
			else if(code=='.'){
				out.print(mem[offset])
			}
		}
	}
	def compile(input: InputStream, block: Block): Block = {
		val code = in.read()
		if(code== -1||code==']') return block

		if(code=='['){
			return block.add(compile(input, new Block()))
		}
		else return compile(input, block.add(new Exp(code)))
	}
	def main(args: Array[String]){
		val block = compile(in, new Block('['))
		block.eval(0)
	}
}