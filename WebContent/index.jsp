<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8" import="java.io.*,java.util.*,org.json.*;"%>
<%
   if (request.getParameter("token").equals("yqMjTrNG5IZj8dBF0jip7yBY")) {
	   ServletContext ctx = getServletContext();
	   String[] nums = {"one","two","three","four","five","six","seven","eight","nine"};
	   ArrayList<String> board = (ArrayList<String>) ctx.getAttribute("currentBoard");
	   Map<String, String> params = new HashMap<String, String>();
	   String lPlayer = (String) ctx.getAttribute("lPlayer");
	   String[] numArray = {"1","2","3","4","5","6","7","8","9"};
	   ArrayList<String> players = (ArrayList<String>) ctx.getAttribute("players");
	   String lastMove = (String) ctx.getAttribute("lastMove");
	   String currentBoard = "";
	   Enumeration parameterNames = request.getParameterNames();
	   String text = null;
	   String currentUser = null;
	   String moveSpot = null;
	   String whoseMove = null;
	   String userCommand = null;
	   JSONObject json = new JSONObject();
	   String jTxt = "text";
	   json.put("response_type","in_channel");
	   while(parameterNames.hasMoreElements()) {
	      String paramName = (String)parameterNames.nextElement();
	      String paramValue = request.getParameter(paramName);
	      params.put(paramName, paramValue);
	   }
	   userCommand = params.get("text");
	   currentUser = params.get("user_name");
	   if (!Arrays.asList(numArray).contains(userCommand)) {
		   if (userCommand.startsWith("vs")){
			   json.remove(jTxt);
			   if (players == null) {
				   players = new ArrayList<String>();
			       players.add(currentUser);
			       players.add(userCommand.substring(3).replace(" ", ""));
			       ctx.setAttribute("players",players);
			   }
			   if (currentUser.equals(players.get(0))) {
				   json.put(jTxt,currentUser+" challenges "+players.get(1)+". Do you accept, " + players.get(1) + "?  (type slash command and then 'yes' or 'no')");
			   }
			   else if (currentUser.equals(players.get(1))){
				   json.put("text",currentUser+" challenges "+players.get(0)+". Do you accept, " + players.get(0) + "?  (type slash command and then 'yes' or 'no')");
			   }
			   ctx.setAttribute("lPlayer", currentUser);
			   out.print(json);
		   }
		   if (players == null) {
			   out.print("Invite another player by typing 'vs' after the slash command.");
			   return;
		   }
		   else if (!players.contains(currentUser)) {
			   out.print(currentUser+", please wait for the next opportunity to play");
			   return;
		   }
		   else if (userCommand.equals("yes") && players.contains(currentUser)) {
			   json.remove(jTxt);
			   if (lPlayer.equals(currentUser)) {
				   out.print("Invitee has not responded.");
				   return;
			   }
			   else if (currentUser.equals(players.get(0))) {
				   json.put(jTxt,players.get(0)+" accepts.  It is now your turn, "+ players.get(1));
			   }
			   else if (currentUser.equals(players.get(1))){
				   json.put(jTxt,players.get(1)+" accepts.  It is now your turn, "+ players.get(0));
			   }
			   ctx.setAttribute("lPlayer", currentUser);

			   out.print(json);
		   }
		   else if (userCommand.equals("no") && players.contains(currentUser)) {
			   json.remove(jTxt);
			   if (lPlayer.equals(currentUser)) {
				   out.print("Invitee has not responded.");
				   return;
			   }
			   else if (currentUser.equals(players.get(0))) {
				   json.put(jTxt,players.get(0)+" declines.  The court is open.");
			   }
			   else if (currentUser.equals(players.get(1))){
				   json.put("text",players.get(1)+" declines.  The court is open.");
			   }
			   out.print(json);
		   }
		   else if (userCommand.equals("status")) {
			   for (String move : board){
			    	  currentBoard += move;
			       }
			   if (lPlayer.equals(players.get(0))){
				   out.print(currentBoard+"\nPlayers: "+players.get(0)+" and "+players.get(1)+". It is now "+players.get(1)+"'s turn.");
			   }
			   else {
				   out.print(currentBoard+"\nPlayers: "+players.get(0)+" and "+players.get(1)+". It is now "+players.get(0)+"'s turn.");
			   }
		   }
	   }
	   else {
		   if (players == null) {
			   out.print(":no_entry:Game has not properly started yet. Please invite another player to play (\"/ttt vs username\")");
			   return;
		   }
		   if (!players.contains(currentUser)) {
			   out.print(currentUser+", please wait for the next opportunity to play");
			   return;
		   }
		   if (currentUser.equals(lPlayer)) {
			   out.print(":no_entry:Not your turn, "+currentUser+":exclamation:");
		   	   return;
		   }
		   else {         
			  if (currentUser.equals(players.get(0))) {
				      whoseMove = ":x:";
			  }
			  else {
				   	  whoseMove = ":o:";
			  }
			  moveSpot = nums[Integer.parseInt(userCommand)-1];
			  text = ":"+moveSpot+":";	
			  board.set(board.indexOf(text),whoseMove);
			  int userMoves = 0;
		      for (String move : board){
		    	  if (move.startsWith(":x:") || move.startsWith(":o:")) {
		    		  userMoves++;
		    	  }
		    	  currentBoard += move;
		       }
		      ctx.setAttribute("currentBoard", board);
		      boolean win = (board.get(0).equals(board.get(1)) && board.get(1).equals(board.get(2))) || 
		  	    		(board.get(0).equals(board.get(4)) && board.get(4).equals(board.get(8))) ||
		  	      		(board.get(0).equals(board.get(5)) && board.get(5).equals(board.get(10))) ||
		  				(board.get(1).equals(board.get(5)) && board.get(5).equals(board.get(9))) ||
		  				(board.get(2).equals(board.get(5)) && board.get(5).equals(board.get(8))) ||
		  				(board.get(2).equals(board.get(6)) && board.get(6).equals(board.get(10))) ||
		  				(board.get(4).equals(board.get(5)) && board.get(5).equals(board.get(6))) ||
		  				(board.get(8).equals(board.get(9)) && board.get(9).equals(board.get(10)));
		      json.remove(jTxt);
		      if (userMoves < 9) {
		    	  if (win) {
		  				json.put(jTxt,currentBoard+"\n"+currentUser+" just won!  Play again?");
		  	      }
		    	  else {
		    		  if (currentUser.equals(players.get(0))){
		    			  json.put(jTxt,currentBoard+"\n"+currentUser+" (the "+whoseMove.substring(1,2).toUpperCase()+" player)"+" just made a move. It is now "+players.get(1)+"'s turn.");
		    		  }
		    		  else {
		    			  json.put(jTxt,currentBoard+"\n"+currentUser+" (the "+whoseMove.substring(1,2).toUpperCase()+" player)"+" just made a move. It is now "+players.get(0)+"'s turn.");
		    		  }
		    	  }
		    	  out.print(json);
		    	  ctx.setAttribute("lPlayer", currentUser);
		      }
		      else {
		    	  if (win) {
		  				json.put(jTxt,currentBoard+"\n"+currentUser+" just won!  Play again?");
		  	      }
		    	  else {
					  json.put(jTxt,currentBoard+"\nDraw.  Play again?");
		    	  }
		    	  out.print(json);
		      }		      
		   }
	   }
   }
%>