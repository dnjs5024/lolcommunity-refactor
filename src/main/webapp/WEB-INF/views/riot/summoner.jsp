<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">
   <!-- Link Swiper's CSS -->
<link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css">
<title>Company Bootstrap Template - Index</title>
<meta content="" name="descriptison">
<meta content="" name="keywords">
<%@ include file="/common/head.jsp" %>
<style type="text/css">
table {
    font-family: arial;
    background-color: #CDCDCD;
    margin: 10px 0pt 15px;
    font-size: 11px;
    width: 690px;
    text-align: left;
}
</style>
</head>
<body>
<!-- ======= Header ======= -->
<%@ include file="/common/header.jsp" %>   
   <!-- ======= Hero Section ======= -->
   <section id="hero" style="height:150vh;padding: 0 0 0 0">
   	<c:if test="${user ne null}">
   	<div style="padding: 50px 0 100px 500px; width:100%;  height:250px; color: white ">
   	  <div class="profile"  style=" float:left;margin-right: 20px; text-align:center;">
		<div style="margin-right:5px; align-items: center;">
			<img src="http://ddragon.leagueoflegends.com/cdn/16.3.1/img/profileicon/${user.summonerInfoIcon}.png" style="width:120px; height:120px;" border="1px solid red">
		</div>
		<div style="padding-top:5px;">
		 <span  style="font-size:25px; font-weight:bold;">${user.summonerInfoName}</span><br>
		</div>
     </div>
     <div  style="float:left;padding-left: 70px">
		<div style="float:left"><img src="/resources/emblem/${user.summonerInfoTier}.png" alt="리그 등급" width="120px" style="border:0px;"></div>
		<div style="float:left">
			리그: 솔로랭크 5x5<br>
			<span>레벨: ${user.summonerInfoLevel}</span><br>
			등급: <b><font color="#228822">${user.summonerInfoTier} ${user.summonerInfoRank}</font></b><br>
			리그 포인트: ${user.summonerInfoPoint}<br>
			 ${user.summonerInfoWins+user.summonerInfoLosses}전 ${user.summonerInfoWins}승 ${user.summonerInfoLosses}패 
			 (${Math.floor(user.summonerInfoWins*1000/(user.summonerInfoWins+user.summonerInfoLosses))/10}%)<br>
			 <button onclick="gameData()">업데이트</button>
		</div>
	 </div>
	</div>
	
	  <div id="gamePage" align="center">
	  </div>	
	  </c:if>
	 <c:if test="${user eq null}">
	 	검색 결과가 없습니다
	 </c:if>
   </section>
<script>
window.addEventListener("load", function(){
	gamePage(1);
	gameData();
});
function gameData(){
	$('.gameInfo').css('display','block')
	$.ajax({
		url:'/games/${param.summoner}',
		method:'GET',
		success:function(res){
			console.log("게임 데이터 로드 완료:", res);
			gamePage(1);
		}
	})
}
function gamePage(pageNo){
	if(!pageNo || pageNo <= 0){
		pageNo = 1;
	}
	$('.gameInfo').css('display','block')
	$.ajax({
		url:'/gamePage/${param.summoner}/'+pageNo,
		method:'GET',
		success:function(res){
            $("#gamePage").html(res);
		}
	})
}
</script>
<%@ include file="/common/footer.jsp" %>
</body>
</html>
