<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta content="width=device-width, initial-scale=1.0" name="viewport">

<title>Company Bootstrap Template - Index</title>
<meta content="" name="descriptison">
<meta content="" name="keywords">
<%@ include file="/common/head.jsp" %>
</head>
<style>
.services .icon-box {
    text-align: center;
    padding: 10px 20px 10px 20px;
    transition: all ease-in-out 0.3s;
    background-color: #000000;
    
}
.section-bg {
    background-color: #333333;
}
ul li{
	margin:0px 0px 0px 0px; 
}
.portfolio #portfolio-flters li {
    cursor: pointer;
    display: inline-block;
    padding: 8px 20px 10px 20px;
    font-size: 15px;
    color: white;
    font-weight: 400;
    line-height: 1;
    text-transform: uppercase;
    transition: all 0.3s;
    border-radius: 2px;
    background: #6EC1E4;
}
.portfolio #portfolio-flters li.filter-active {
    color: #fff;
    background: #000000;
}

.portfolio #portfolio-flters2 li {
    cursor: pointer;
    display: inline-block;
    padding: 8px 20px 10px 20px;
    font-size: 15px;
    color: white;
    font-weight: 400;
    line-height: 1;
    text-transform: uppercase;
    transition: all 0.3s;
    border-radius: 2px;
    background: #6EC1E4;
}
.portfolio #portfolio-flters2 li.filter-active2 {
    color: #fff;
    background: #000000;
}

.portfolio #portfolio-flters3 li {
    cursor: pointer;
    display: inline-block;
    padding: 8px 20px 10px 20px;
    font-size: 15px;
    color: white;
    font-weight: 400;
    line-height: 1;
    text-transform: uppercase;
    transition: all 0.3s;
    border-radius: 2px;
    background: #6EC1E4;
}
.portfolio #portfolio-flters3 li.filter-active3 {
    color: #fff;
    background: #000000;
    border:3px solid red;
}

input[type="text" i] {
    padding: 1px 2px;
    margin-left:50px;
    width: 130px;
}
</style>
<body>
<!-- ======= Header ======= -->
<%@ include file="/common/header.jsp" %>	

  <main id="main">

<section id="portfolio" class="portfolio section-bg" style="padding: 0 0 30px 0;height: 2900px">
<div style="width: 1920px;">
		<div style="width: 38%; margin: 100px 0 0 300px;float: left">
	        <div class="row aos-init aos-animate" style="width: 100%;" data-aos="fade-up">
	          <div class=" d-flex justify-content-center">  
	            <ul id="portfolio-flters" style="margin-bottom: 0;"> 
	              <li class="filter-active" onclick="getList()">All</li>
	              <li onclick="getPostion('top')" >탑</li>
	              <li onclick="getPostion('jungle')">정글</li>
	              <li onclick="getPostion('mid')">미드</li>
	              <li onclick="getPostion('bot_carry')">바텀</li>
	              <li onclick="getPostion('bot_support')">서포터</li>
	              <li onclick="getPostion('rotation')">로테이션</li>
	            </ul>
				<input type="text" id="champName" onkeyup="doSearch(); ">
	          </div> 
	         </div>
	        <div class="row" style="width: 100%;background: black; " id="champList"></div> 
        </div>
        
        
        
         
	        <div style="width: 380px; margin: 100px 0 0 200px;float: left;"> 
	         <div class="row aos-init aos-animate" align="center"  data-aos="fade-up" style="margin: 0 0 0 0; background-color: none; ">  
		          <div class=" d-flex justify-content-center" >
		            <ul id="portfolio-flters2" style="margin-bottom: 0;"> 
		              <li class="filter-active2" onclick="getRank('top')" value="top" >탑</li>
		              <li  value="jungle">정글</li>
		              <li  value="mid">미드</li>
		              <li  value="bot-cat">바텀</li>
		              <li  value="bot-sup">서포터</li>
		            </ul> 
		          </div>
		      </div>
		       
			<table  id="champList" style="padding: 0px; width: 100%; background: #ce9c33; border: 1px solid black" >
			 <c:forEach begin="0" end="19" var="i">
				<tr style="margin: 5px 5px 5px 5px; border: 1px solid black; background: white;">
					<td style="width:10px; text-align: center;">${i+1}</td> 
					<td id="rankImg${i}">
						
					</td>
					<td id="rank${i}" style="padding-left: 10px">
					</td>
				</tr>
			  </c:forEach>
		     </table> 
		   </div>
		   <div style="float: left; margin: 133px 0 0 0; text-align: center;  font-family: Roboto;width: 35px"> 
	            <ul id="portfolio-flters3" style="margin-bottom: 0; "> 
	              <li class="filter-active3"  style="background: #ce9c33;font-size: 30px; color: black;" id="GOLD">GOLD</li>
	              <li  style="background: #eeeeee; font-size: 30px; color: black;"  id="SILVER">SILVER</li>
	              <li  style="background: #e69c11; font-size: 30px; color: black;" id="BRONZE">BRONZE</li>
	              <li  style="background: white; font-size: 30px; color: black;" id="IRON">IRON</li>
	            </ul>
		   </div> 
	  </div>
	  
    </section><!-- End Services Section -->
  </main><!-- End #main -->
<%@ include file="/common/footer.jsp" %>	
<script>
window.addEventListener('load',getList);
window.addEventListener('load',getRank);

function getList(){
	$.ajax({
		url:'/champList',
		method:'GET',
		success:function(res){
			var html ='';
			for(var champ of res){
				html +='<div class="align-items-stretch" align="center" style="padding: 0px;" name="champ">';
				html +='<div class="icon-box iconbox-blue" style="padding: 0px;  width: 120px">';
				html +='<div class="icon">';
				html +='<a href="/champion/'+champ.championInfoId+'">';
				html +='<img src="http://ddragon.leagueoflegends.com/cdn/16.3.1/img/champion/'+champ.championInfoId+'.png" width="80px">';
				html +='</a></div>';
				html +='<h4 style=" cursive;color: yellow;font-size: 14px;margin: 0;width: auto;color: white">'+champ.championInfoName+'</h4>';
				html += '</div></div>';
			}
			$('#champList').html(html);
		}
		
	}) 
}


function doSearch(){

    var value, names;

    value = document.getElementById("champName").value.toUpperCase();
    names = document.getElementsByName("champ");
    for(var name of names){
      if(name.innerHTML.toUpperCase().indexOf(value) > -1){
    	  name.style.display = "flex";
      }else{
    	  name.style.display = "none";
      }
    }
  }

function getRank(){
	
	var position = $('.filter-active2').text();
	var tier = $('.filter-active3').text();
	
	if(position === '미드'){
		position = 'mid';
	}else if(position === '정글'){
		position = 'jungle';
	}else if(position === '탑'){
		position = 'top';
	}else if(position === '바텀'){
		position = 'bot_carry';
	}else{
		position = 'bot_support';
	}
	
	var data = {
			position : position,
			tier : tier
	}
	console.log(data);
	$.ajax({
		url:'/champion/rank', 
		contentType:'application/json',
		method:'POST',
		data:JSON.stringify(data),
		success:function(res){
			for(var i=0; i<20; i++){
				var kda = res[i].kda;
				var avgPick = res[i].avgPick;
				var avgWin = res[i].avgWin;
				var position = res[i].position; 
				var champ = res[i].champion;
				$('#rank'+i).html(champ.championInfoName+'<br> KDA : '+kda+' / 승률 : '+avgWin+'% / 픽률 : '+avgPick+'%');
				$('#rankImg'+i).html('<img src="http://ddragon.leagueoflegends.com/cdn/16.3.1/img/champion/'+champ.championInfoId+'.png" width="60px" style="margin-left: 5px;">');
			}
		}
		
	})
}
function getPostion(position){
	var data = {
			position:position
	}
	$.ajax({
		url:'/champ/position', 
		method:'GET',
		data:data,
		success:function(res){
			var html =''; 
			for(var champ of res){
				html +='<div class="align-items-stretch" align="center" style="padding: 0px;" name="champ">';
				html +='<div class="icon-box iconbox-blue" style="padding: 0px;  width: 120px">';
				html +='<div class="icon">';
				html +='<a href="/champion/'+champ.championInfoId+'">';
				html +='<img src="http://ddragon.leagueoflegends.com/cdn/16.3.1/img/champion/'+champ.championInfoId+'.png" width="80px">';
				html +='</a></div>';
				html +='<h4 style="cursive;color: yellow;font-size: 14px;margin: 0;width: auto;color: white">'+champ.championInfoName+'</h4>';
				html += '</div></div>';
			}
			$('#champList').html(html);
		}
		
	})
}


</script>
</body>
</html>
