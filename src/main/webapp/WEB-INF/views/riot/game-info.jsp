<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


  <table border="1" style="font-size: 20px;width: 1398px;">
  <tr style=" text-align: center;">
  	<th>승</th>
  	<th>챔피언</th>
  	<th>타입</th>
  	<th>KDA</th>
  	<th>S/R</th>
  	<th>팀</th>
  	<th>아이템</th>
  	<th>LV/DG/CS</th>
  	<th>플레이</th>
  	<th>와드</th>
  	<th></th>
  </tr>
  <c:if test="${game.size() == 0}">
  	<tr style=" text-align: center;">
  	<td colspan="11">기록된 전적이 없거나 업데이트해 주시길 바랍니다.</td>
  	</tr>
  </c:if>
 <c:forEach items="${game}" var="match">
  <c:forEach items="${match}" var="data">
   
  	<c:if test="${data.mMatchGame != null}">
  	<tr class="recent_game">
				<td class="game_win" style=" vertical-align: middle; text-align: center;">${data.mMatchGame.matchGameWin}</td>
				<td class="recent_td recent_champ" 
					style=" vertical-align: middle; text-align: center; width: 52px; padding: 0px;"><div
						style="position: relative; width: 100%; height: 100%;">
						<img src="http://ddragon.leagueoflegends.com/cdn/16.3.1/img/champion/${data.mChamp.championInfoId}.png" 
						alt="챔피언" width="100" height="100">
						<div
							style="position: absolute; width: 100px; height: 25px; bottom: 0px; text-align: center; background-color: black; filter: alpha(opacity = 80); -moz-opacity: 0.8; opacity: 0.8; color: white; font-size: 20px;">
							<b>${data.mChamp.championInfoName}</b>
						</div>
					</div></td>
				<td class="recent_td"
					style=" vertical-align: middle; text-align: center; padding: 2px;"><b>랭크</b></td>
				<td class="recent_td"
					style=" vertical-align: middle; text-align: center; padding: 0px;"><font
					color="#449944"><b>평점 ${data.kda}</b></font>
					<br>${data.mMatchGame.matchGameKills} / ${data.mMatchGame.matchGameDeaths} / ${data.mMatchGame.matchGameAssists}<span
					style="font-size: 18px; font-family: arial;"></span></td>
				<td class="recent_td"
					style=" vertical-align: middle; text-align: center; width: 130px; padding: 0px;">
					<img width="50" style="margin-left: 5px;" src="http://ddragon.leagueoflegends.com/cdn/16.3.1/img/spell/${data.mSpell1.summonerSpellId}.png">
					<img class="show_new_build tipsy_live" alt="룬"
					src="http://ddragon.leagueoflegends.com/cdn/img/${data.mRune1.runeImgPath}"
					style="width: 50px; border: 0; cursor: pointer;">
					<DIV style='text-align:left;display: none;'><SPAN style='color:#8F8; font-weight:700;'>${data.mRune1.runeName}</SPAN>${data.mRune1.runeDesc}</DIV><br>
					
					<img width="50" src="http://ddragon.leagueoflegends.com/cdn/16.3.1/img/spell/${data.mSpell2.summonerSpellId}.png">
					<img class="show_new_build tipsy_live" alt="룬"
					src="http://ddragon.leagueoflegends.com/cdn/img/${data.mRune2.runeImgPath}"
					style="width: 40px; margin-left:5px; opacity: 0.3; border: 0; cursor: pointer;">
					<DIV style='text-align:left;display: none;;'><SPAN style='color:#8F8; font-weight:700;'>${data.mRune2.runeName}</SPAN>${data.mRune2.runeDesc}</DIV><br>
				</td>
				<td class="recent_td">
				<div style="margin-bottom: 5px">
				<c:forEach begin="0" end="4" var="i">
				<c:if test="${match[i].champ.championInfoId !=null}">
						<img src="http://ddragon.leagueoflegends.com/cdn/16.3.1/img/champion/${match[i].champ.championInfoId}.png"
							alt="카시오페아" tipsy="카시오페아" width="50">
				</c:if>
				</c:forEach>
					</div>
					<div>
				<c:forEach begin="5" end="9" var="i">
				<c:if test="${match[i].champ.championInfoId !=null}">
						<img src="http://ddragon.leagueoflegends.com/cdn/16.3.1/img/champion/${match[i].champ.championInfoId}.png"
							alt="카시오페아" tipsy="카시오페아" width="50">
				</c:if>
				</c:forEach>
					</div></td>
				<td class="recent_td"><div
						style="position: relative; width: 100%; height: 100%;">
						<div style="margin-bottom: 5px">
						<c:if test="${data.mItems.matchItem0 !=0}">
							<img width="50"
								 src="https://opgg-static.akamaized.net/meta/images/lol/16.3.1/item/${data.mItems.matchItem0}.png?image=q_auto:good,f_webp,w_64,h_64&v=1603"
							tipsy="정령의 형상">
						</c:if>
						<c:if test="${data.mItems.matchItem0 ==0}">
							<img width="50"
							src="http://ddragon.leagueoflegends.com/cdn/img/bg/F5141416.png">
						</c:if>
						
						<c:if test="${data.mItems.matchItem1 !=0}">
							<img width="50"
								 src="https://opgg-static.akamaized.net/meta/images/lol/16.3.1/item/${data.mItems.matchItem1}.png?image=q_auto:good,f_webp,w_64,h_64&v=1603"
							tipsy="정령의 형상">
						</c:if>
						<c:if test="${data.mItems.matchItem1 ==0}">
							<img width="50"
							src="http://ddragon.leagueoflegends.com/cdn/img/bg/F5141416.png">
						</c:if>
						
						<c:if test="${data.mItems.matchItem2 !=0}">
							<img width="50"
								 src="https://opgg-static.akamaized.net/meta/images/lol/16.3.1/item/${data.mItems.matchItem2}.png?image=q_auto:good,f_webp,w_64,h_64&v=1603"
							tipsy="정령의 형상">
						</c:if>
						<c:if test="${data.mItems.matchItem2 ==0}">
							<img width="50"
							src="http://ddragon.leagueoflegends.com/cdn/img/bg/F5141416.png">
						</c:if>
						
						<c:if test="${data.mItems.matchItem6 !=0}">
							<img width="50"
								 src="https://opgg-static.akamaized.net/meta/images/lol/16.3.1/item/${data.mItems.matchItem6}.png?image=q_auto:good,f_webp,w_64,h_64&v=1603"
							tipsy="정령의 형상">
						</c:if>
						<c:if test="${data.mItems.matchItem6 ==0}">
							<img width="50"
							src="http://ddragon.leagueoflegends.com/cdn/img/bg/F5141416.png">
						</c:if>
						</div>
						<div>
						<c:if test="${data.mItems.matchItem3 !=0}">
							<img width="50"
								 src="https://opgg-static.akamaized.net/meta/images/lol/16.3.1/item/${data.mItems.matchItem3}.png?image=q_auto:good,f_webp,w_64,h_64&v=1603"
							tipsy="정령의 형상">
						</c:if>
						<c:if test="${data.mItems.matchItem3 ==0}">
							<img width="50"
							src="http://ddragon.leagueoflegends.com/cdn/img/bg/F5141416.png">
						</c:if>
						<c:if test="${data.mItems.matchItem4 !=0}">
							<img width="50"
								 src="https://opgg-static.akamaized.net/meta/images/lol/16.3.1/item/${data.mItems.matchItem4}.png?image=q_auto:good,f_webp,w_64,h_64&v=1603"
							tipsy="정령의 형상">
						</c:if>
						<c:if test="${data.mItems.matchItem4 ==0}">
							<img width="50"
							src="http://ddragon.leagueoflegends.com/cdn/img/bg/F5141416.png">
						</c:if>
						<c:if test="${data.mItems.matchItem5 !=0}">
							<img width="50"
								 src="https://opgg-static.akamaized.net/meta/images/lol/16.3.1/item/${data.mItems.matchItem5}.png?image=q_auto:good,f_webp,w_64,h_64&v=1603"
							tipsy="정령의 형상">
						</c:if>
						<c:if test="${data.mItems.matchItem5 ==0}">
							<img width="50"
							src="http://ddragon.leagueoflegends.com/cdn/img/bg/F5141416.png">
						</c:if>
						</div>

							
					</div></td>
				

	 			<td class="recent_td"
					style=" vertical-align: middle; text-align: center; padding: 0px; font-size: 18px;">레벨
					${data.mMatchGame.matchGameLevel}<br>
				<b>피해량 ${data.mMatchGame.totalDamage}</b><br>
				<span class="tipsy_live" style="font-size: 18px;"
					tipsy="미니언킬 / 분당CS<BR/>적정글: 0" original-title="">CS : ${data.mMatchGame.matchGameCs}</span>
				</td>
				<td class="recent_td"
					style=" vertical-align: middle; text-align: center;  font-size: 18px;"><span
					style="font-size: 18px;" >${data.playTime} </span><br>
				<span 
					style="font-size: 18px;">${data.betweenTime}</span></td>
				<td class="recent_td tipsy_live"
					style="line-height: 14px; font-size: 18px;  vertical-align: middle; text-align: center;"
					tipsy="제어와드 구매<BR>와드설치/와드제거"><img
					src="https://opgg-static.akamaized.net/images/lol/item/2055.png" alt="제어와드 설치 수"
					style="width: 30px; border: 0; height: 30px; margin: 4px; vertical-align: middle;">${data.mMatchGame.visionWardsBought}
					<br>${data.mMatchGame.wardsPlaced} / ${data.mMatchGame.wardsKilled}</td>
					
				<td class="recent_td" onclick="get_bt_api(4372029880,this,'KR');"
					style=" vertical-align: middle; text-align: center; font-size: 18px; cursor: pointer;">▼</td>
   			</tr>
			</c:if>
    </c:forEach>
   </c:forEach>
 </table>
<br>
<script>
	var recentGames = document.querySelectorAll('.recent_game');
	var gameWins = document.querySelectorAll('.recent_game > .game_win');
	
	for(var i=0; i< gameWins.length;i++){
		var win = gameWins[i].innerText;
		if(win=='win'){
			recentGames[i].style.background = 'rgb(0 0 255 / 15%)';
		}else{
			recentGames[i].style.background = 'rgb(255 0 0 / 15%)';
		}
	}

</script>
